function [gitcommit, comment] = get_gitcommit()
% git commit version
[status,cmdout] = system('git rev-parse HEAD');
if status == 0
    gitcommit = cmdout(1:7);
    comment = cmdout(9:end);
else
    gitcommit = '';
    comment = '';
end

[status,cmdout] = system('git status --porcelain');
if status == 0
    if ~isempty(cmdout)
        warning('Working directory not clean (i.e. uncommitted/unpushed) files exist. Use git commit -am "<message>"; git push')
    end
end