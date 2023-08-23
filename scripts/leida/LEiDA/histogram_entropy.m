function H = histogram_entropy(Cm)

n_channels = size(Cm, 1);

Ldata = n_channels*n_channels;
bines = round(sqrt(Ldata));
    
x=Cm(:);

P=hist(x,bines)/Ldata;

I=find(P~=0); P=P(I);

H = -sum(P.*log(P))./log(bines); %shannon

end