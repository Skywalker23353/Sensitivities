function [SPD] = set_latex_labels(SPD,FCONFIG)
    fieldNames = fieldnames(SPD);
    for i = 1:length(fieldNames)
        fName = fieldNames{i};
        SPD.(fName).opname = FCONFIG{i,2};
        SPD.(fName).latexLabel = FCONFIG{i,3};
    end
end