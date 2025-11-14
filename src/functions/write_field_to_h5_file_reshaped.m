function write_field_to_h5_file_reshaped(fieldNames,N_fields,inner_s,outer_s,inner,outer,outdir,filename)

    h5_filename = sprintf('%s/%s.h5',outdir,filename);
    fname = split(filename,'_');
    if isfile(h5_filename); delete(h5_filename);end
    h5_grids_filename = sprintf('%s/%s_grids_0.h5',outdir,fname{1});
    if isfile(h5_grids_filename); delete(h5_grids_filename);end
    phase_name = fname{1};
    grid_name1 = 'Inner';
    grid_name2 = 'Outer';
    
    for i = 1:N_fields
        fieldName = fieldNames{i};
        fprintf("Writing %s \n",fieldName);
        
        inner_field_rh = inner_s.(fieldName);
        inner_field_lh = flip(inner_field_rh,2);

        outer_field_rh = outer_s.(fieldName);
        outer_field_lh = flip(outer_field_rh,2);
    
        inner_field = cat(2,inner_field_lh(:,1:end-1),inner_field_rh);
        outer_field = cat(2,outer_field_lh(:,1:end-1),outer_field_rh);
   
        %% Creating 3D domain 
        inner_R_lh = -flip(inner.R,2);
        inner_bilat_R = cat(2,inner_R_lh(:,1:end-1),inner.R);
        [nrc,ncc] = size(inner_bilat_R);
        x_inner = zeros(nrc,ncc,2);
        x_inner(:,:,1) = inner_bilat_R;
        x_inner(:,:,2) = inner_bilat_R;
        y_inner = zeros(nrc,ncc,2);
        inner_Z_lh = flip(inner.Z,2);
        inner_bilat_Z = cat(2,inner_Z_lh(:,1:end-1),inner.Z);  
        y_inner(:,:,1) = inner_bilat_Z;
        y_inner(:,:,2) = inner_bilat_Z;
        z_inner = zeros(nrc,ncc,2);
        z_inner(:,:,1) = ones(nrc,ncc)*1e-3;
        z_inner(:,:,2) = -1e-3*ones(nrc,ncc);
        field_inner_3D = zeros(nrc,ncc,2);
        field_inner_3D(:,:,1) = inner_field;
        field_inner_3D(:,:,2) = inner_field;
        %
        outer_R_lh = -flip(outer.R,2);
        outer_bilat_R = cat(2,outer_R_lh(:,1:end-1),outer.R);
        [nrn,ncn] = size(outer_bilat_R);
        x_outer = zeros(nrn,ncn,2);
        x_outer(:,:,1) = outer_bilat_R;
        x_outer(:,:,2) = outer_bilat_R;
        y_outer = zeros(nrn,ncn,2);
        outer_Z_lh = flip(outer.Z,2);
        outer_bilat_Z = cat(2,outer_Z_lh(:,1:end-1),outer.Z);  
        y_outer(:,:,1) = outer_bilat_Z;
        y_outer(:,:,2) = outer_bilat_Z;
        z_outer = zeros(nrn,ncn,2);
        z_outer(:,:,1) = ones(nrn,ncn)*1e-3;
        z_outer(:,:,2) = -1e-3*ones(nrn,ncn);
        
        field_outer_3D = zeros(nrn,ncn,2);
        field_outer_3D(:,:,1) = outer_field;
        field_outer_3D(:,:,2) = outer_field;
        %% Writing

        if ~isfolder(outdir);mkdir(outdir);end

        if i==1 % writing grids file only once
            x_comb_path = sprintf('/%s/source_blocks/0/x',grid_name1);
            h5create(h5_grids_filename,x_comb_path,size(x_inner));
            y_comb_path = sprintf('/%s/source_blocks/0/y',grid_name1);
            h5create(h5_grids_filename,y_comb_path,size(y_inner));
            z_comb_path = sprintf('/%s/source_blocks/0/z',grid_name1);
            h5create(h5_grids_filename,z_comb_path,size(z_inner));
            h5write(h5_grids_filename,x_comb_path,x_inner);
            h5write(h5_grids_filename,y_comb_path,y_inner);
            h5write(h5_grids_filename,z_comb_path,z_inner);

            x_noz_path = sprintf('/%s//source_blocks/0/x',grid_name2);
            h5create(h5_grids_filename,x_noz_path,size(x_outer));
            y_noz_path = sprintf('/%s/source_blocks/0/y',grid_name2);
            h5create(h5_grids_filename,y_noz_path,size(y_outer));
            z_noz_path = sprintf('/%s/source_blocks/0/z',grid_name2);
            h5create(h5_grids_filename,z_noz_path,size(z_outer));
            h5write(h5_grids_filename,x_noz_path,x_outer);
            h5write(h5_grids_filename,y_noz_path,y_outer);
            h5write(h5_grids_filename,z_noz_path,z_outer);
        end

        field_path_c = sprintf('/%s/%s/fields/0/%s',phase_name,grid_name1,fieldName);
        h5create(h5_filename,field_path_c,size(field_inner_3D));
        h5write(h5_filename,field_path_c,field_inner_3D);
        
        
        
        field_path_n = sprintf('/%s/%s/fields/0/%s',phase_name,grid_name2,fieldName);
        h5create(h5_filename,field_path_n,size(field_outer_3D));
        h5write(h5_filename,field_path_n,field_outer_3D);
    end
        % h5close();
end