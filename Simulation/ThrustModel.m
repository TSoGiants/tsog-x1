%Thrust Model

%This code represents how thrust is caclculated in the x and y directions
%Thrust calculated from RPM and Airspeed. The equation used can be found here:
%https://www.electricrcaircraftguy.com/2014/04/propeller-static-dynamic-thrust-equation-background.html
%This function returns an array of Thrust in the x and y directions

function Thrust = ThrustModel(SimData)
  %constants we get from propeller 
  diameter = 6; % Inches
  pitch = 3; % Inches (how far forward propeller moves in one rotation)
  Kv = 2280; % RPM per volt
  Max_Volt = 4.2; % Volts
  Min_Volt = 3; % Volts
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Note that Kv*Max_Volt = Max Theoretical RPM.
  %To scale down this RPM, we will use the 'Throttle' input, which is a percentage
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %%How to get Throttle:
  battery_cap_percent = SimData.Plane.Cap/SimData.Plane.MaxCap; 
  Throttle = SimData.TestCase.GetThrottle(SimData.Time);
  diff_Volt = Max_Volt - Min_Volt
  voltage = (Min_Volt + diff_Volt*battery_cap_percent)* Throttle; % Voltage sent to the motor
  airspeed = norm(SimData.StateVector.Velocity)#linear velocity of plane in x,y plane
  RPM = Kv*voltage;%RPM based on Kv and Voltage
  
  Thrust = 4.392399*10^(-8)*RPM*diameter^(3.5)*pitch^(-.5)*((4.23333*10^(-4))*RPM*pitch-airspeed);%calculate thrust (based on model in excel file)
  
  #Calculations to update battery
  Power = Thrust * airspeed;
  if(voltage == 0)
    current = 0;
  else
    current = Power / (voltage); %in amps
  endif
  battery_update = (current*1000) * (SimData.dt/3600); %in mAh
  
  %Calculate X,Y directions
  Pitch = SimData.StateVector.Orientation; %this is an angle in degrees
  Thrust_x = Thrust*cosd(Pitch);
  Thrust_y = Thrust*sind(Pitch);
  %Return value
  Thrust = [Thrust_x,Thrust_y,battery_update];
endfunction