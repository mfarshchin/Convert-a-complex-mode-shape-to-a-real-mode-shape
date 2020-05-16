function Real=ComplexModeToRealMode(Complex)

% This function converts the complex mode shape to the real valued one
% Reference: Operationa modal analysis of civil engineering structures page
% 182 and 183

% Rotate the complex mode shapes (see the RotationMaxCor function, below)
Complex=RotationMaxCor(Complex);

 % 1: find the modulus of the mode shape
 Modul=abs(Complex);
 
 % 2: normalize the modulus
 if nargin < 2
    Modul=Modul/max(Modul);
 end
 
 % 3: Find the phase of each component
 Phase=angle(Complex);
 
 % 4: find the sign of each component
 for I=1:size(Complex,1)
     if Modul(I,1)~=0
        Sign(I,1)=SignFinder(Phase(I));
     else
         Sign(I,1)=0;
     end
 end
 
 % 5: compute the real valued mode shape
 Real=Modul.*Sign;
  
end


function Sign=SignFinder(In)

if In>=0 && In<pi/2
    % First quarter
    Sign=+1;
elseif In>=pi/2 && In<=pi
    % Second quarter
    Sign=-1;
elseif In>=-pi && In<-pi/2
    % Third quarter
    Sign=-1;
elseif In>=-pi/2 && In<0
    % Forth quarter
    Sign=+1;
end

end

function out=RotationMaxCor(In)

% This function computes the maximum correlation line and then rotate the
% data with respect to this correlation 

X=real(In);
Y=imag(In);
p=polyfit(X,Y,1);% Fit a first order line to the data

Teta=-atan(p(1)); % angle of maximum correlation line

Rot=[cos(Teta)  -sin(Teta) ; sin(Teta)  cos(Teta)]; % Rotation matrix

for I=1:size(In,1);
    N=Rot*[X(I);Y(I)];
    out(I,1)=N(1)+N(2)*1i;
end
end