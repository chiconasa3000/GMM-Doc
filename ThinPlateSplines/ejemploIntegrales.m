function  ejemploIntegrales(d,k,r)

wd = 0;kk = 0;
%wd = (1-r)^(floor((1/2)*d)+k+1);
%iterando
for kk=1:1:k
    wd = int(t*(1-t)^(floor((1/2)*d)+k+1),r,1)
end

end

    

syms t
int(t*(1-t)^(floor((1/2)*d)+k+1),0,1)

syms x
y = x^2;
x = 5;
subs(y)