function  Main()
    name='';
    
    for obj_num=4:4         %����� �������
        for i=67:2000       %����� �������
            %name=strcat( num2str(i),'.tif'); %rotate_2_1.tif ��� ���������
            disp(i)

            %name=strcat('Rotate/rotate_',num2str(56),'_',num2str(i),'.tif');
            %Binarity(name, i);


            %obj_num = 1;
            %name1=strcat('Rand/Binar/object_',num2str(obj_num),'/',num2str(obj_num),'_',num2str(i),'.tif');
            %name2=strcat('Rand/Kontur/object_',num2str(obj_num),'/',num2str(obj_num),'_',num2str(i),'.tif');

            %%%Only for Normalization
            name=strcat('Normalization/', num2str(obj_num),'/', num2str(i),'.tif'); %rotate_2_1.tif
            Filter=imread(name);     
            len=size(Filter);

            level = graythresh(Filter);         %����� ����
            level = round(level*10)/11;         %����������
            Binarity=im2bw(Filter, level);      %����������� �� ������
            %������� ����� � �����
            for x = 1:1:len(1)
                for y = 1:1:len(2)
                    if x==1  || x==len(1)
                        Binarity(x,y)=1;
                    end
                    if y==1  || y==len(2)
                        Binarity(x,y)=1;
                    end
                end
            end
            %figure, imshow(Binarity), title('�����������');
            imwrite(Binarity,strcat('Normalization/Binarity/object_',num2str(obj_num),'/',num2str(obj_num),'_',num2str(i),'.tif'));
            BW=imfill(~Binarity,'holes');
            Kontur = edge(~BW,'canny');    %��������� ������ �������
            erosy = bwmorph(Kontur, 'shrink', 3);       %������
            %%%    figure, imshow(~erosy), title('������1');
            imwrite(~erosy,strcat('Normalization/Kontur/object_',num2str(obj_num),'/',num2str(obj_num),'_',num2str(i),'.tif'));

            name1=strcat('Normalization/Binarity/object_',num2str(obj_num),'/',num2str(obj_num),'_',num2str(i),'.tif');
            name2=strcat('Normalization/Kontur/object_',num2str(obj_num),'/',num2str(obj_num),'_',num2str(i),'.tif');                          
            %%%
            
            Only_Priznaki(obj_num, i, name1, name2)
            %Povorots(name);
            %Random(i);
        end
   end
%     name=strcat( num2str(1),'.tif');
%     Binarity(name, 1);
% 
%     for x=1:10
%         name=strcat( num2str(x),'.tif');
%         Binarity(name, x);        
%     end
end