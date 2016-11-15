function setRestraint(self,uID)
%% classdef nodes
% 
% note:
% * uses self.ucsid
% * assumes each call is for only a single freedom case (but does accept
% array of nodeIndices and restraints)
%
% nodeInd:
% node index
%
% fcase:
% freedom case number
%
% restrain [nnodes x 6dof]:
% [0..5]
% A 6 element array describing the restraint conditions for the six DoF at the
% specified node.  Status[i-1] = btTrue indicates that the i th DoF is
% restrained. The DoF are restrained according to the 123456 axis convention
% in the specified UCS.
%
% doubles [nnodes x 6dof]
% [0..5]
% A 6 element array describing the enforced displacement conditions for the six
% DoF at the specified node.  Doubles[i-1] describes the displacement of
% the i th DoF according to the 123456 axis convention in the specified UCS.
% 
% author: john devitis
% create date: 15-Aug-2016 17:31:52

    global btTrue btFalse
    
    restraint = self.restraint;
    
    disp = self.disp;
    if isempty(disp)
        disp = zeros(size(self.restraint));
    end
    
    % Make sure that restraint is 1 when displacement is imposed
    if isempty(restraint)
        restraint = zeros(size(disp));
        restraint(disp~=0) = 1;    
    end
    
    fcase = self.fcase;
    if isempty(fcase)
        fcase = 1;
    end   
    
    % loop node indices
    for ii = 1:length(self.id)
        
        % sort 0/1 logicals to btTrue/btFalse globals
        for jj = 1:length(restraint(ii,:))
            if restraint(ii,jj) == 0
                status(ii,jj) = btFalse;
            else
                status(ii,jj) = btTrue;
            end
        end
        
        % set restraint for node(ii)
        iErr = calllib('St7API','St7SetNodeRestraint6',uID,self.id(ii),...
            fcase,self.ucsid,status(ii,:),disp(ii,:));
        HandleError(iErr)
    end

end