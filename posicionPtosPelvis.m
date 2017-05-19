function ptos = posicionPtosPelvis(bw)

figure, imshow(bw)

bw2 = imfill(bw,'holes');
L = bwlabel(bw2);
s = regionprops(L, 'centroid');
centroids = cat(1, s.Centroid);
ptos = centroids;
%Display original image and superimpose centroids.
hold(imgca,'on')
plot(imgca,centroids(:,1), centroids(:,2), 'r*')
hold(imgca,'off')
end
