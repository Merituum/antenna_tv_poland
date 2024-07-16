'# MWS Version: Version 2024.1 - Oct 16 2023 - ACIS 33.0.1 -

'# length = m
'# frequency = MHz
'# time = ns
'# frequency range: fmin = 180 fmax = 720
'# created = '[VERSION]2024.1|33.0.1|20231016[/VERSION]


'@ use template: Antenna - Wire_2.cfg

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
'set the units
With Units
    .SetUnit "Length", "mm"
    .SetUnit "Frequency", "MHz"
    .SetUnit "Voltage", "V"
    .SetUnit "Resistance", "Ohm"
    .SetUnit "Inductance", "nH"
    .SetUnit "Temperature",  "degC"
    .SetUnit "Time", "ns"
    .SetUnit "Current", "A"
    .SetUnit "Conductance", "S"
    .SetUnit "Capacitance", "pF"
End With

ThermalSolver.AmbientTemperature "0"

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "180", "720"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

Mesh.FPBAAvoidNonRegUnite "True"
Mesh.ConsiderSpaceForLowerMeshLimit "False"
Mesh.MinimumStepNumber "5"
Mesh.RatioLimit "20"
Mesh.AutomeshRefineAtPecLines "True", "10"

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "10"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With MeshSettings
     .SetMeshType "Srf"
     .Set "Version", 1
End With
IESolver.SetCFIEAlpha "1.000000"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "180;450;720"
Dim sDefineAtName As String
sDefineAtName = "180;450;720"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ define material: Aluminum

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Material
     .Reset
     .Name "Aluminum"
     .Folder ""
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "3.56e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "Kelvin"
     .Mu "1.0"
     .Sigma "3.56e+007"
     .Rho "2700.0"
     .ThermalType "Normal"
     .ThermalConductivity "237.0"
     .SpecificHeat "900", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "69"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "23"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ new component: component1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Component.New "component1"

'@ define brick: component1:boom1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Brick
     .Reset 
     .Name "boom1" 
     .Component "component1" 
     .Material "Aluminum" 
     .Xrange "0", "0.01" 
     .Yrange "0", "0.003" 
     .Zrange "0", "1.5" 
     .Create
End With

'@ define units

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Units 
     .SetUnit "Length", "m"
     .SetUnit "Temperature", "degC"
     .SetUnit "Voltage", "V"
     .SetUnit "Current", "A"
     .SetUnit "Resistance", "Ohm"
     .SetUnit "Conductance", "S"
     .SetUnit "Capacitance", "pF"
     .SetUnit "Inductance", "nH"
     .SetUnit "Frequency", "MHz"
     .SetUnit "Time", "ns"
     .SetResultUnit "frequency", "frequency", "" 
End With

'@ define cylinder: component1:solid1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.05" 
     .InnerRadius "0.04" 
     .Axis "x" 
     .Xrange "0", "0" 
     .Ycenter "0.05" 
     .Zcenter "0" 
     .Segments "0" 
     .Create 
End With

'@ delete shape: component1:solid1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Delete "component1:solid1"

'@ define cylinder: component1:solid1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0.003", "0.420" 
     .Xcenter "0.005" 
     .Zcenter "0.208" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid2

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0", "-0.346" 
     .Xcenter "0.005" 
     .Zcenter "0.459" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid3

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid3" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0.003", "0.290" 
     .Xcenter "0.005" 
     .Zcenter "0.668" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid4

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid4" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0", "-0.238" 
     .Xcenter "0.005" 
     .Zcenter "0.841" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid5

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid5" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0.003", "0.201" 
     .Xcenter "0.005" 
     .Zcenter "0.985" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid6

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid6" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0", "-0.164" 
     .Xcenter "0.005" 
     .Zcenter "1.104" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid7

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid7" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0.003", "0.139" 
     .Xcenter "0.005" 
     .Zcenter "1.203" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid8

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid8" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0", "-0.113" 
     .Xcenter "0.005" 
     .Zcenter "1.285" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid9

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid9" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0.003", "0.097" 
     .Xcenter "0.005" 
     .Zcenter "1.353" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid10

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid10" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0", "-0,078" 
     .Xcenter "0.005" 
     .Zcenter "1.410" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid11

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "0.005" 
     .InnerRadius "0.0049" 
     .Axis "y" 
     .Yrange "0.003", "0.068" 
     .Xcenter "0.005" 
     .Zcenter "1.460" 
     .Segments "0" 
     .Create 
End With

'@ boolean add shapes: component1:solid1, component1:solid10

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:solid1", "component1:solid10"

'@ boolean add shapes: component1:solid11, component1:solid2

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:solid11", "component1:solid2"

'@ boolean add shapes: component1:solid3, component1:solid4

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:solid3", "component1:solid4"

'@ boolean add shapes: component1:solid5, component1:solid6

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:solid5", "component1:solid6"

'@ boolean add shapes: component1:solid7, component1:solid8

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:solid7", "component1:solid8"

'@ boolean add shapes: component1:solid7, component1:solid9

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:solid7", "component1:solid9"

'@ boolean add shapes: component1:solid1, component1:solid11

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:solid1", "component1:solid11"

'@ boolean add shapes: component1:solid3, component1:solid5

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:solid3", "component1:solid5"

'@ boolean add shapes: component1:solid3, component1:solid7

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:solid3", "component1:solid7"

'@ boolean add shapes: component1:solid1, component1:solid3

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:solid1", "component1:solid3"

'@ boolean add shapes: component1:boom1, component1:solid1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:boom1", "component1:solid1"

'@ transform: mirror component1:boom1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:boom1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "0.7", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:boom1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:boom1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "-0.07", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ paste structure data: 1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With SAT 
     .Reset 
     .FileName "*1.cby" 
     .SubProjectScaleFactor "1" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With

'@ transform: translate component1:boom1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:boom1_1" 
     .Vector "-0.01", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:boom1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:boom1_1" 
     .Vector "-0.005", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: rotate component1:boom1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:boom1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "180" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: translate component1:boom1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:boom1_1" 
     .Vector "0.02", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:boom1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:boom1_1" 
     .Vector "0", "0.003", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ pick center point

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickCenterpointFromId "component1:boom1_1", "58"

'@ pick center point

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickCenterpointFromId "component1:boom1", "45"

'@ define discrete port: 1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "75"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "True", "0.03", "0.0015", "1.5"
     .SetP2 "True", "0.005", "0.0015", "1.5"
     .InvertDirection "False"
     .LocalCoordinates "False"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ set PBA version

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Discretizer.PBAVersion "2023101624"

'@ define time domain solver parameters

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-80"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ change solver type

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
ChangeSolverType "HF Time Domain"

'@ define time domain solver parameters

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-30"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

