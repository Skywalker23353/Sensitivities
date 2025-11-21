function [SNST,LES] = reshape_sensitivities_and_grid(SNST,LES)
     %Reshaping grid from noz and comb to Inner and outer grids
     lip_idx = find(LES.Comb.R(1,:) >= 0.001,1);
     r_diff_vec = abs(LES.Comb.R(:,(lip_idx-1)) - 0.001);
     LES.Comb.R(:,(lip_idx-1)) = LES.Comb.R(:,(lip_idx-1)) + r_diff_vec;
     r_diff_vec_n = abs(LES.Noz.R(:,end) - 0.001);
     LES.Noz.R(:,end) = LES.Noz.R(:,end) + r_diff_vec_n;

     [~,nozCols] = size(LES.Noz.R);
     InnerCols = nozCols;
     LES.Inner.R = cat(1,LES.Noz.R,LES.Comb.R(2:end,1:nozCols));
     LES.Inner.Z = cat(1,LES.Noz.Z,LES.Comb.Z(2:end,1:nozCols));
     LES.Outer.R = LES.Comb.R(:,InnerCols:end);
     LES.Outer.Z = LES.Comb.Z(:,InnerCols:end);

     LES = rmfield(LES,'Comb');
     LES = rmfield(LES,'Noz');
    
     OldGridNames = fieldnames(SNST);
     NewGridNames = {'Inner';'Outer'};

     gridname = OldGridNames{1};
     fieldNames = fieldnames(SNST.(gridname));
 
     for j = 1:length(fieldNames)
        fieldName = fieldNames{j};
        SNST.(NewGridNames{1}).(fieldName) = cat(1,SNST.Noz.(fieldName),SNST.Comb.(fieldName)(2:end,1:nozCols)); 
     end

     for j = 1:length(fieldNames)
        fieldName = fieldNames{j};
        SNST.(NewGridNames{2}).(fieldName) = SNST.Comb.(fieldName)(:,InnerCols:end); 
     end

     SNST = rmfield(SNST,'Comb');
     SNST = rmfield(SNST,'Noz');
     
end