via=~strcmp(cellstr(via_alg),'Negative');
vili=~strcmp(cellstr(vili_alg1),'Negative');
for i=1:length(via)
    if vili(i)==0
        predict(i)=0;
    elseif vili(i)==1
        if via(i)==1
            predict(i)=1;
        else
            predict(i)=0.5;
        end
    end
end
predict2=predict';