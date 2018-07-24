function getDICOMFromViva()
% tt = 1;
answer1 = inputdlg('Please enter your sample number');
    answer2 = {'00000'};%inputdlg('Please enter the first measurement number you would like to retrieve the DICOM files for');
    answer3 = uigetdir(pwd,'Please choose a folder in which to dump all the DICOM files');
% while tt == 1
    f = ftp('10.21.24.203','microct','mousebone4','System','OpenVMS');
    binary(f);
%     answer1 = inputdlg('Please enter your sample number');
%     answer2 = inputdlg('Please enter the first measurement number you would like to retrieve the DICOM files for');
%     answer3 = uigetdir(pwd,'Please choose a folder in which to dump all the DICOM files');
    
    
    
    cd(f,'dk0');
    cd(f,'data');
    cd(f,['00000' answer1{1}]);
    directories = dir(f);
%     progressbar()
    for i = 1:length(directories)
        if directories(i).isdir == 1 && str2num(directories(i).name(1:8)) > str2num(answer2{1})
            cd(f,directories(i).name(1:8));
            for j = 1:20
                clear files;
                files = dir(f,'*.dcm*');
                if ~isempty(files)
                    getTheFiles(answer3,directories(i),files,f);
                end
            end
            cd(f,'..');
        end
    end
%     pause(600)
% end


function getTheFiles(answer3,directories,files,f)

if ~isempty(files)
    sysLine = ['md "' answer3 '\' directories.name(1:8) '"'];
    system(sysLine);
end
for j = 1:length(files)
    clc
    j/length(files)
    mget(f,files(j).name,[answer3 '\' directories.name(1:8)]);
    delete(f,files(j).name);
end

