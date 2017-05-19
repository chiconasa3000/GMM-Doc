function graphGridControl(ptosTest1,ptosTest2)
    [num,dim] = size(ptosTest1);
    z = zeros(num,1);
    r = zeros(num,1);
    for i=1:1:num
        %mix(i,:) = (ptosTest1(i,1) - ptosTest2(i:1))^2;
        %miy(i,:) = (ptosTest1(i,2) - ptosTest2(i:2))^2;
        r(i,:) = calcRad(ptosTest1(i,:),ptosTest2(i,:));
        z(i,:) = funcU(r(i,:));
    end
    nuevox = (ptosTest1(:,1)-ptosTest2(:,1)).^2; %X2
    nuevoy = (ptosTest1(:,2)-ptosTest2(:,2)).^2; %Y2
    [X,Y] = meshgrid(nuevox, nuevoy);
    Z = sqrt(X+Y).*log(sqrt(X+Y));
    surf(Z);
end