function fm2ws(FM)
% FM2WS    Assign fields of FM in variables in the workspace.
%    FM2WS(FM) assigns the contents of the fields of the fuzzy
%    model structure FM to variables in the workspace. These
%    variables have the same names as the fields.

% Copyright (c) Robert Babuska, 1998.

f = fieldnames(FM);
for i = 1 : length(f),
   assignin('caller',f{i},getfield(FM,f{i}));
end;

