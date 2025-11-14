function [SNST] = smooth_sensitivities_near_dump_plane(SNST,COORD)
    GridNames = fieldnames(SNST);
    fieldNames = fieldnames(SNST.(GridNames{1}));
    dump_plane_idx = find(abs(COORD.Z(:,1)) < 1e-16);

    for i = 1:length(fieldNames)
        fieldName = fieldNames{i};
        Field = SNST.(GridNames{1}).(fieldName);
        subField = Field(dump_plane_idx - 1:dump_plane_idx + 1,end);
        subField = myutils.f_return_smooth_field(subField,2,'col');
        Field(dump_plane_idx - 1:dump_plane_idx + 1,end) = subField;
        SNST.(GridNames{1}).(fieldName) = Field;
    end
end