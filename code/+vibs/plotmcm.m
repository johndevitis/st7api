function plotmcm(x,y,mcm)
%% Syntax: plotmcm(x,y,mcm);
%
% jdv 3/19/14

h = figure;
dim = 2;

shapedcolorplot(h,dim,x,y,[],mcm);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% shapedcolorplot.m
%
% 2D or 3D plot using additional values to fill the object with the
% appropriate colormap. Useful to represent surface properties.
%
% Input: figure handle ([] if unknown), plot dimension (2 or 3), x,y,z ([] if 2D),
%        vector of property values used to create the colormap
% Output: shaped colorplot, eventually figure handle and matrix containing colormap
% 
% Warning: 1) Consider changing the size of "pnt" in accordance to the graph
%             size and inter-point distance
%          2) The colormap contains 14 levels for reading clarity
%          3) The graph creation can take some time for large matrices 
%        
% Fanny Besem
% August 3rd, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[matrix_col]=shapedcolorplot(h,dim,x,y,z,values)

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Additional inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%
flag=0;
pnt=85; % To be changed if the figure contains white holes

%%%%%%%%%%%%%%%%%%%%%%%% Get current handle if h is empty %%%%%%%%%%%%%%%%
if isempty(h),
    h=gcf;
end

%%%%%%%%%%%%%%%%%% Make sure the inputs are vector-columns %%%%%%%%%%%%%%%
if size(x,2)>size(x,1),
    x=x';
end
if size(y,2)>size(y,1),
   y=y';
end
if size(z,2)>size(z,1),
    z=z';
end
if size(values,2)>size(values,1),
    values=values';
end

%%%%%%%%%%%%%%%%%%%%%%% Error messages and warnings %%%%%%%%%%%%%%%%%%%%%
if dim~=2 && dim~=3,
    error('The dimension you specified is invalid, try "2" or "3"');
    flag=1;
end
if dim==3 && isempty(z),
    error('A 3-dimension plot require a z-component');
    flag=1;
end
if dim==2 && not(isempty(z)),
    warning('The z-component is not supposed to be provided for a 2-dimension plot, the input will not be used');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main routine %%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag==0,
    
    matrix_col=zeros(size(values,1),3);
    MIN=min(values(:,1));
    MAX=max(values(:,1));
    level=(MAX-MIN)/14;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Colormap  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    c1=[0.2 0 0];
    c2=[0.5 0 0];
    c23=[0.8 0 0];
    c3=[1 0 0];
    c4=[1 0.5 0];
    c45=[1 0.7 0];
    c5=[1 1 0];
    c6=[0.7 1 0];
    c7=[0.2 1 0];
    c78=[0 .9 1];
    c8=[0 0.7 0.8];
    c9=[0 0.5 1];
    c10=[0 0.2 0.8];
    c11=[0 0 0.5];
    map=[c11;c10;c9;c8;c78;c7;c6;c5;c45;c4;c3;c23;c2;c1];
    
    %%%%%%%%%%%%%%%%%%%%%%%% Creation of the colormap matrix  %%%%%%%%%%%%%%%
    for i=1:size(values,1),
        if values(i)>=MIN && values(i)<MIN+level,
            matrix_col(i,1:3)=c11;
        elseif values(i)>=MIN+level && values(i)<MIN+2*level,
            matrix_col(i,1:3)=c10;
        elseif values(i)>=MIN+2*level && values(i)<MIN+3*level,
            matrix_col(i,1:3)=c9;
        elseif values(i)>=MIN+3*level && values(i)<MIN+4*level,
            matrix_col(i,1:3)=c8;
        elseif values(i)>=MIN+4*level && values(i)<MIN+5*level,
            matrix_col(i,1:3)=c78;
        elseif values(i)>=MIN+5*level && values(i)<MIN+6*level,
            matrix_col(i,1:3)=c7;
        elseif values(i)>=MIN+6*level && values(i)<MIN+7*level,
            matrix_col(i,1:3)=c6;
        elseif values(i)>=MIN+7*level && values(i)<MIN+8*level,
            matrix_col(i,1:3)=c5;
        elseif values(i)>=MIN+8*level && values(i)<MIN+9*level,
            matrix_col(i,1:3)=c45;
        elseif values(i)>=MIN+9*level && values(i)<MIN+10*level,
            matrix_col(i,1:3)=c4;
        elseif values(i)>=MIN+10*level && values(i)<MIN+11*level,
            matrix_col(i,1:3)=c3;
        elseif values(i)>=MIN+11*level && values(i)<MIN+12*level,
            matrix_col(i,1:3)=c23;
        elseif values(i)>=MIN+12*level && values(i)<MIN+13*level,
            matrix_col(i,1:3)=c2;
        else
            matrix_col(i,1:3)=c1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%% Creation of the plots %%%%%%%%%%%%%%%%%%%%%%%%%
    if dim==2,
        figure(h)
        scatter(x,y,pnt,matrix_col,'filled');
        axis equal;
        disp('Shaped colorplot successfully created');
        colormap(map)
        hcb = colorbar('YTickLabel',...
            {num2str(MIN),num2str(MIN+level),num2str(MIN+2*level),num2str(MIN+3*level),num2str(MIN+4*level),num2str(MIN+5*level),...
            num2str(MIN+6*level),num2str(MIN+7*level),num2str(MIN+8*level),num2str(MIN+9*level),num2str(MIN+10*level),...
            num2str(MIN+11*level),num2str(MIN+12*level),num2str(MIN+13*level),num2str(MIN+14*level)});
        set(hcb,'ytick',[0:1/14:1])
    elseif dim==3,
        figure(h)
        scatter3(x,y,z,pnt,matrix_col,'filled');
        axis equal
        disp('Shaped colorplot successfully created');
        colormap(map)
        hcb = colorbar('YTickLabel',...
            {num2str(MIN),num2str(MIN+level),num2str(MIN+2*level),num2str(MIN+3*level),num2str(MIN+4*level),num2str(MIN+5*level),...
            num2str(MIN+6*level),num2str(MIN+7*level),num2str(MIN+8*level),num2str(MIN+9*level),num2str(MIN+10*level),...
            num2str(MIN+11*level),num2str(MIN+12*level),num2str(MIN+13*level),num2str(MIN+14*level)});
        set(hcb,'ytick',[0:1/14:1])
    end
end

end
