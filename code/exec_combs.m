function out = exec_combs(parpath,jid,tid)
arguments
    parpath char
    jid(1,1) double
    tid(1,1) double
end
% EXEC_COMBS execute parameter combinations (task-level on SLURM)
%--------------------------------------------------------------------------
% Inputs:
%  parpath - filepath to parameter file
%
%  jid - job ID
%
%  tid - task ID
%
% Outputs:
%  out - output from execfn (which is in the parameter file). If
%  argoutnames is a non-scalar vector of chars, then out is a struct.
%  Otherwise, out is the first output of execfn.
%
% Usage:
%  a = b(a);
%
% Dependencies:
%  exec_argfn.m
%   --get_argvals.m
%    --get_argnames.m
%
% See also WRITEPARFILE
%
% Author(s): Sterling Baird
%
% Date: 2020-09-07
%--------------------------------------------------------------------------

%% load and unpack
load(parpath,'execfn','argoutnames','parcombsets','diarypathfn','savepathfn')

%% execution
if size(argoutnames,1) ~= 1
    %make into row vector
    argoutnames = argoutnames.';
    assert(size(argoutnames,2) == 1,'at least one dimension of argoutnames should be 1')
end

%unpack based on job id and task id
parcombset = parcombsets{jid,tid};
ncombs = length(parcombset); %number of parameter combinations
%% loop through parameter combinations
for i = 1:ncombs
    %% setup
    %unpack parameter
    parcombs = parcombset(i);
    
    %diary entry    
    diarypath = exec_argfn(diarypathfn,parcombs);
    diary(diarypath)
    
    %% execute function
    out = exec_argfn(execfn,parcombs,argoutnames);

    %% output
    savepath = exec_argfn(savepathfn,parcombs);
    save(savepath,'out','-v7.3')
    
    %close diary entry
    diary('off')
end


%% CODE GRAVEYARD
%{
% for i = 1:Ntrim(jid)


% vars = {'execfn','argoutnames','parcombsets', 'Ntrim'};
% S = load(parpath,vars{:});
% parcombsets = S.parcombsets;
% execfn = S.execfn;
% Ntrim = S.Ntrim;
% argoutnames = S.argoutnames;

% folder = fullfile('data','randOctParity');
% fnamefn = @(method,ndatapts,gitcommit,uuid) [method int2str(ndatapts) '_gitID-' gitcommit(1:7) '_uuID-' uuid '.txt'];
% fpathfn = @(method,ndatapts,gitcommit,uuid) fullfile(folder,fnamefn(method,ndatapts,gitcommit,uuid));

%input/output setup for execfn
n = length(argoutnames); %number of output arguments of execfn

    %diary entry
    [~,argvals] = get_args(parcombs,diarypathfn);
    diarypath = savepathfn(argvals{:});
    diary(diarypath)

    %input/output setup for execfn
    clear argout
    argout = cell(1,n); %row vector
    [~,argvals] = get_args(parcombs,execfn);
    
    %% execute function
    [argout{:}] = execfn(argvals{:});
    
    %% output
    %package output
    NVpairs = reshape([argoutnames;argout],[],1); %interleave names and values
    out = struct(NVpairs{:}); %package into struct with supplied names as fields
    
    %save output to file
    [~,argvals] = get_args(parcombs,savepathfn);
    savepath = savepathfn(argvals{:});
    save(savepath,'out')

%     %warning: following code uses evalc
%     for j = 1:n
%         var = argoutnames{n};
%         val = argout{n}; %temporary value of variable
%         evalc([var '= val']); %assign temp value to the variable name
%     end



%}