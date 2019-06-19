
instance = [.05, .1];  %x1  x2 
target =[ .01, .99];  % T1  T2
      
      
weight =   [.15, .25 ;
            .2,  .3  ; 
            .4,  .5  ; 
            .45, .55];       % W1  W2  W3  W4  W5  W6  W7  W8
        
bios =     [.35, .35, .6, .6];    % B1  B1    B2  B2
eta = 0.1;
x0 = 1; 
nLayer = [2, 2];


out_seg_Yh= [];
out_seg_Ok = [];
Result = [];

          %%         FORWARD    

for i = 1:length(instance)
    %weight(i,1)* out1 + weight(i,2)* out2 + bios(i)
   out_seg_Yh(i) = 1/(1+exp(-(weight(i,1)* instance(1) + weight(i,2)* instance(2) + bios(i))));
end


for i = 1:length(target)
    %weight(i,1)* out1 + weight(i,2)* out2 + bios(i)
   out_seg_Ok(i) = 1/(1+exp(-(weight((length(instance)+i),1)* out_seg_Yh(1) + weight((length(instance)+i),2)* out_seg_Yh(2) + bios(length(instance)+i))));
end
disp("Actual output: ");
disp([out_seg_Yh, out_seg_Ok]);
 
      %%         BACKWORD

for i=1:2
    for j=1:length(out_seg_Ok)
        if i == 1
            Result(j) = out_seg_Ok(j)*(1 - out_seg_Ok(j))*(target(j) - out_seg_Ok(j));
        else
            Result(length(Result)+1)=out_seg_Yh(j)*(1-out_seg_Yh(j))*(Result(j)*weight(i+1,j)+Result(j+1)*weight(i+2,j));
        end
    end         
end

Result = Sort(Result, nLayer) ;
disp("Error : ")
disp(Result);

deltaWeight = [] ;
for i = 1:length(Result)
    for j = 1:2
        if i <= 2
             deltaWeight = [deltaWeight , (eta * Result(i) * instance(j))] ;
        else
             deltaWeight = [deltaWeight , (eta * Result(i) * out_seg_Yh(j))] ;
        end
    end
end

        %% Update weight
        
disp("Delta Weight : ")
disp(deltaWeight)

count = 1 ;
for i = 1:length(weight)
    for j = 1:2
        weight(i,j) = (weight(i,j) + deltaWeight(count));
        count = count + 1 ;
    end 
end
disp("New Weight : ")
disp(weight)

    %% Update Bios
    
deltaBios = [];    
for i = 1:length(Result)
    deltaBios = [deltaBios, (eta * Result(i) * x0)];
end    

disp("Delta Bios : ");
disp(deltaBios);

for j = 1:length(bios)
    bios(j) = bios(j) + deltaBios(j);
end    
 
disp("New Bios : ");
disp(bios);
