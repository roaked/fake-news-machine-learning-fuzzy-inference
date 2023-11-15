function k0 = fmorder(ny,nu)

if ~isempty([ny{1}{:}]) 
    maxnya = 0; %max([ny{1}{:}]); 
    for jo = 1:size(ny{1},1)
        for jojo = 1:size(ny{1},2)
            maxnya = max([maxnya ny{1}{jo,jojo}]);
        end
    end   
else  maxnya = 0; 
end   
if ~isempty([ny{2}{:}]) 
    maxnyc = 0;%max([ny{2}{:}]); 
    for jo = 1:size(ny{2},1)
        for jojo = 1:size(ny{2},2)
            maxnyc = max([maxnyc ny{2}{jo,jojo}]);
        end
    end   
    
else  
    maxnyc = 0; 
end   
if ~isempty([nu{1}{:}]) 
    %maxnua = max([nu{1}{:}]); 
    maxnua = 0;  
    for jo = 1:size(nu{1},1)
        for jojo = 1:size(nu{1},2)
            maxnua = max([maxnua nu{1}{jo,jojo}]);
        end
    end
else  
    maxnua = 0; 
end   
if ~isempty([nu{2}{:}]) 
    %maxnuc = max([nu{2}{:}]); 
    maxnuc = 0; 
    for jo = 1:size(nu{2},1)
        for jojo = 1:size(nu{2},2)
            maxnuc = max([maxnuc nu{2}{jo,jojo}]);
        end
    end   
else  
    maxnuc = 0; 
end   

maxny = max(maxnya,maxnyc); 
maxnu = max(maxnua,maxnuc);

k0 = max(max(maxny+1,maxnu+1),2); 