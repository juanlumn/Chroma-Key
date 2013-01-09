function I3=Chroma(I1,I2,media,tolerancia)
%Picture for the chroma
[M1,N1,C1]=size(I1);
%Background Picture
[M2,N2,C2]=size(I2);
M=M1;
N=N1;
%Width and Height adjusted for the smaller pic
if M2<M1 
    M=M2;
end
if N2<N1 
    N=N2;
end
%Computes the HSV
[H1,S1,V1]=rgb2hsv(I1);
[H2,S2,V2]=rgb2hsv(I2);
%Computes the Hue parameters
for i=1:M
    for j=1:N
        if round(S1(i,j)*100)>10&&round(V1(i,j)*100)>10
            if round(H1(i,j)*360)>=media-tolerancia&&round(H1(i,j)*360)<=media+tolerancia
                H1(i,j)=H2(i,j);
                S1(i,j)=S2(i,j);
                V1(i,j)=V2(i,j);
            end
        end
    end
end
%Returns to RGB
I3=hsv2rgb(H1,S1,V1);
