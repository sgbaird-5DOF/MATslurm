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