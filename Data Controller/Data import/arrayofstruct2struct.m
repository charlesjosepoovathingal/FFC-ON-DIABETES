function stackstruct = arrayofstruct2struct(arrayofstruct)
%
% STACKSTRUCT = ARRAYOFSTRUCT2STRUCT(ARRAYOFSTRUCT) compress an array of
% struct to a structure by checking each field and replace identical values
% by the single appropriate one (string or numeric). If the values are
% different then ARRAYOFSTRUCT2STRUCT convert them into the appropriate
% stacked format (cell for string or array for numeric)
%
% Manuel Petit, May 2018
% manuel.petit@inserm.fr
% modified 7/7/18, l.broche@abdn.ac.uk: adding recursive test for cell
% arrays and mutliple dimensions

% check input
if max(size(arrayofstruct)) == 1
    disp('Warning: input is not an array of structure')
    stackstruct = arrayofstruct;
    return
end

if iscell(arrayofstruct)
    % case when the input is a cell array
    % go back to the case of an array of object and re-run the function
    % over all the elements of the cell array
    
    subarrayofstruct = cellfun(@(x) x,arrayofstruct(:));
    stackstruct = arrayofstruct2struct(subarrayofstruct);
    
else
    fld = fieldnames(arrayofstruct); 
    val = cell(size(fld));

    for i = 1:length(fld)
        % check if the value is a string
        if ischar(arrayofstruct(1).(fld{i}))
            v = {arrayofstruct.(fld{i})}; % get all the values
            % check if the string is repeated along the array
            if all(strcmp(v(1),v(2:end)) == 1)
                val{i} = v{1};
            else
                val{i} = v;
            end
        elseif isnumeric(arrayofstruct(1).(fld{i}))
            if length(arrayofstruct(1).(fld{i}))==1
                v = [arrayofstruct.(fld{i})]; % get all the values 
                % check if the number/array is repeated along the array
                if all(v == v(1))
                    val{i} = v(1);
                else
                    val{i} = v;
                end
            else
                % case when the data needs to be stacked in 3D
                v = [arrayofstruct.(fld{i})]; % get all the values 
                v = reshape(v,length(arrayofstruct(1).(fld{i})),length(arrayofstruct))';
                % check if the number/array is repeated along the array
                if all(v == v(1))
                    val{i} = v(1);
                else
                    val{i} = v;
                end
            end
        else
            v = {arrayofstruct.(fld{i})}; % get all the values
            % check if the string is repeated along the array
            if all(strcmp(v(1),v(2:end)) == 1)
                val{i} = v{1};
            else
                val{i} = v;
            end
        end
    end
    stackstruct = cell2struct(val,fld,1);
end

end

