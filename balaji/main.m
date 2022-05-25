% fileDir = [curr_dir '/']; %PARENT FOLDER
% scp_file =  'noisy_file_list'; %list of all the files for feature extraction
% ftr_Dir = 'my_features/noisy/';


fileDir = [curr_dir '/']; %PARENT FOLDER
scp_file =  'clean_file_list'; %list of all the files for feature extraction
%%%%%%%%% EDIT THIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ftr_Dir = 'my_features/clean/'; %location of the parent folder to store 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%the extracted features

curr_dir = pwd;

fid=fopen(scp_file,'r');
count=1;
while ~feof(fid)
    
    tline = fgets(fid);
    temp_in = regexp(tline,'[\r\f\n]','split');
    temp = temp_in{1};
    filenames{count} = temp;
    count=count+1;
    
end
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for cnt = 1:length(filenames)
    
    fileName = filenames{cnt};
    snd_FilePath =  [fileDir fileName];
    fprintf('Processing %s\n', fileName);

    inds = strfind(fileName,'/');
    dirstore = [curr_dir '/' 'nssp_' fileName(1:inds(end)-1)];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Windows users might need to edit this %%%%
    if(~exist(dirstore))
        system(['mkdir -p ' dirstore]);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [rawdata, fsamp] = audioread(snd_FilePath);
    processed_audio = transpose(NSSP(rawdata,fsamp));

    audiowrite([curr_dir '/' 'nssp_' fileName(1:end-4) '.wav'],processed_audio,fsamp);
    
    
end