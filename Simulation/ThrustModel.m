%Thrust Model%MaxThrust = 100;%Throttle = 1;%airspeed = 50;%Thrust = MaxThrust*Throttle*(1-airspeed/50)function [Thrust_x, Thrust_y] = ThrustModel(StateVector)  airspeed = sqrt(StateVector(3)^2 + StateVector(4)^2);  Throttle = StateVector(6);  MaxThrust = 100;  Pitch = StateVector(5);  Thrust = MaxThrust*Throttle*(1-airspeed/50);  Thrust_y = Thrust*sind(Pitch);  Thrust_x = Thrust*cosd(Pitch);
endfunction