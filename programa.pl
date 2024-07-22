% Centro de Estudiantes

% años de elecciones
% elecciones/2 -> Anio.
elecciones(2017).
elecciones(2019).

% Padro de estudiantes regulares organizazo por carrera y año
% estudiantes(Carrera, Anio, Estudiante)
estudiantes(sistemas, 2019, juanPerez).
estudiantes(sistemas, 2019, unter).
estudiantes(sistemas, 2019, mathy).
estudiantes(sistemas, 2017, unter).
estudiantes(sistemas, 2017, mathy).
estudiantes(sistemas, 2018, unter).

% Cantidad de votos obtenidos en cada eleccion
% votos(Agrupacion, Voto, Carrera, Anio).
votos(franjaMorada, 213, sistemas, 2017).
votos(franjaMorada, 21323, sistemas, 2019).
votos(agosto29, 21323, sistemas, 2019).

% Total de votos obtenidos de una agrupacion en un año determinado.
votosAgrupacion(Agrupacion, Anio, TotalVotos) :-
    sePresento(Agrupacion,Anio),                % es una Agrupacion que se presento en tal anio
    votosGeneral(Agrupacion, Anio, TotalVotos).

votosGeneral(Agrupacion,Anio,Total) :-
    findall(Voto,votos(Agrupacion,Voto,_,Anio),ListaDeVotos),
    sumlist(ListaDeVotos, Total).
    
sePresento(Agrupacion,Anio) :- votos(Agrupacion,_,_,Anio).

% PRIMERA PARTE Se quiere averiguar
% 1) Quien ganó cada elección.

%propuesta(franjaMorada).
%propuesta(agosto29).

ganoEleccion(Agrupacion, AnioEleccion) :-
    elecciones(AnioEleccion),
    votosAgrupacion(Agrupacion, AnioEleccion, TotalVotos),
    forall(votosAgrupacion(_,AnioEleccion,OtroTotal),TotalVotos >= OtroTotal).
    
% 2) Si es cierto que siempre gana el mismo

siempreGanaElMismo(Agrupacion) :-
    ganoEleccion(Agrupacion,_),
    forall(elecciones(Anio),ganoEleccion(Agrupacion,Anio)).

% 3) Si hubo fraude en un año en particular, 
% lo que ocurre si hay más votos registrados que electores en el padrón. 

cantidadEstudiantes(Anio,TotalEstudiantes) :-
    elecciones(Anio),
    findall(Estudiante, estudiantes(_,Anio,Estudiante), ListaEstudiantes),
    length(ListaEstudiantes, TotalEstudiantes).
    
huboFraude(Anio) :-
    cantidadEstudiantes(Anio,TotalEstudiantes),
    votosGeneral(_,Anio,TotalVotos),
    TotalEstudiantes < TotalVotos.

% 4) Todos los años en que hubo fraude
% ?- huboFraude(Anio).
