function ctBatchDICOMFromISQ()

template = importdata(['j:\Silva''s lab\Lab People folders\Daniel Leib\Scanco Scripts\DICOM_Batch_Export.COM'],'t',5);

answer1 = inputdlg('Please enter your sample number, three digits for Viva, four digits for Micro');
answer2 = inputdlg('Please enter the first measurement number you would like to reconstruct');
answer3 = inputdlg('Please enter the last measurement number you would like to reconstruct');
    
%generate com file to be used to generate headers files
%to run the com file, you must first execute SET FILE/ATTRIBUTE=RFM:STM and
%type in the full path to the com file when prompted.
if length(answer1{1}) == 4
    comFile = fopen([pwd '\microCTComFile.com'],'wt');
    fprintf(comFile,'%s','$ SET FILE/ATTRIBUTEs=RFM=STM');
    fprintf(comFile,'%s\n','');
    fprintf(comFile,'%s\n','$! Original code created by Dan Leib');
    f = ftp('10.21.24.204','microct','mousebone4');
    ascii(f);
    cd(f,'dk0');
    cd(f,'data');
    dirs = dir(f);%samples
    for i = 1:length(dirs)
        if ~isempty(str2num(dirs(i).name(1:end-6)))
            if dirs(i).isdir == 1 && str2num(dirs(i).name(1:end-6)) == str2num(answer1{1})%check if is a directory
                cd(f,dirs(i).name(1:(end-2)));
                dirs2 = dir(f);%measurements
                for j = 1:length(dirs2)
                    if dirs2(j).isdir == 1 && str2num(dirs2(j).name(1:end-6)) >= str2num(answer2{1}) && str2num(dirs2(j).name(1:end-6)) <= str2num(answer3{1})
                        cd(f,dirs2(j).name(1:end-2));
                        isqs = dir(f,'*.isq*');
                        for k = 1:length(isqs)
                            line1 = strrep(template{1},'SAMPLE',dirs(i).name(1:end-6));
                            line1 = strrep(line1,'MEASUREMENT',dirs2(j).name(1:end-6));
                            line2 = template{2};
                            line3 = strrep(template{3},'CNUMBER',isqs(k).name(1:end-6));
                            line4 = strrep(template{4},'MEASUREMENT',dirs2(j).name(1:end-6));
                            line5 = template{5};
                            fprintf(comFile,'%s\n',line1);
                            fprintf(comFile,'%s\n',line2);
                            fprintf(comFile,'%s\n',line3);
                            fprintf(comFile,'%s\n',line4);
                            fprintf(comFile,'%s\n',line5);
                        end
                        cd(f,'..');%back out of measurement
                    end
                end
            cd(f,'..');%back out of sample
            end
           
        end
    end
    fprintf(comFile,'%s\n','$ EXIT');
    fclose(comFile);
    cd(f,'idisk1:[microct.scratch]');
    mput(f,[pwd '\microCTComFile.com']);
elseif length(answer1{1}) == 3
    comFile = fopen([pwd '\microCTComFile.com'],'wt');
    fprintf(comFile,'%s','$ SET FILE/ATTRIBUTEs=RFM=STM');
    fprintf(comFile,'%s\n','');
    fprintf(comFile,'%s\n','$! Original code created by Dan Leib');
    f = ftp('10.21.24.203','microct','mousebone4');
    ascii(f);
    cd(f,'dk0');
    cd(f,'data');
    dirs = dir(f);%samples
    for i = 1:length(dirs)
        if isempty(strfind(dirs(i).name,'STORAGE'))
        if dirs(i).isdir == 1 && str2num(dirs(i).name(1:end-6)) == str2num(answer1{1})%check if is a directory
            cd(f,dirs(i).name(1:(end-2)));
            dirs2 = dir(f);%measurements
            for j = 1:length(dirs2)
                if dirs2(j).isdir == 1 && str2num(dirs2(j).name(1:end-6)) >= str2num(answer2{1}) && str2num(dirs2(j).name(1:end-6)) <= str2num(answer3{1})
                    cd(f,dirs2(j).name(1:end-2));
                    isqs = dir(f,'*.isq*');
                    for k = 1:length(isqs)
                        line1 = strrep(template{1},'SAMPLE',dirs(i).name(1:end-6));
                        line1 = strrep(line1,'MEASUREMENT',dirs2(j).name(1:end-6));
                        line2 = template{2};
                        line3 = strrep(template{3},'CNUMBER',isqs(k).name(1:end-6));
                        line4 = strrep(template{4},'MEASUREMENT',dirs2(j).name(1:end-6));
                        line5 = template{5};
                        fprintf(comFile,'%s\n',line1);
                        fprintf(comFile,'%s\n',line2);
                        fprintf(comFile,'%s\n',line3);
                        fprintf(comFile,'%s\n',line4);
                        fprintf(comFile,'%s\n',line5);
                    end
                    cd(f,'..');%back out of measurement
                end
            end
            cd(f,'..');%back out of sample
        end
        end
    end
    fprintf(comFile,'%s\n','$ EXIT');
    fclose(comFile);
    cd(f,'disk1:[microct.scratch]');
    mput(f,[pwd '\microCTComFile.com']);
else
    error('Try that sample number again!');
end

if length(answer1{1}) == 4
    runVMSScriptMicro();
else
    runVMSScriptViva();
end