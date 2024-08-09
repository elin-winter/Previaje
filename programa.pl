%%%%%%%%%%%%%%%%%%%%%%%% Base de Conocimientos %%%%%%%%%%%%%%%%%%%%%%%% 

comercioAdherido(iguazu, grandHotelIguazu).
comercioAdherido(iguazu, gargantaDelDiabloTour).
comercioAdherido(bariloche, aerolineas).
comercioAdherido(iguazu, aerolineas).

factura(estanislao, hotel(grandHotelIguazu, 2000)).
factura(antonieta, excursion(gargantaDelDiabloTour, 5000, 4)).
factura(antonieta,vuelo(1515, antonietaPerez)).
factura(antonieta, hotel(grandHotelIguazu, 0)).

valorMaximoHotel(5000).

registroVuelo(1515, iguazu, aerolineas, [estanislaoGarcia, antonietaPerez, danielIto], 10000).

%%%%%%%%%%%%%%%%%%%% Punto 1

montoADevolver(Facturas, Monto):-
    findall(MontoFactura,
        (member(Factura, Facturas), esValida(Factura), calcularMonto(Factura, MontoFactura)), 
        Montos),
    sumlist(Montos, MontoFacturas),
    ciudadesVisitas(Facturas, CantCiudades),
    MontoAgregado is MontoFacturas + 1000 * CantCiudades,
    agregarPenalidad(Facturas, MontoAgregado, MontoPenalidad),
    montoMax(MontoPenalidad, Monto).

esValida(factura(_, hotel(Hotel, Precio))):-
    comercioAdherido(_, Hotel),
    valorMaximoHotel(Max),
    Precio =< Max.

esValida(factura(_, excursion(Excursion, _, _))):-
    comercioAdherido(_,Excursion).

esValida(factura(_, vuelo(NroVuelo, NombreCompleto))):-
    registroVuelo(NroVuelo, _, _, Pasajeros, _),
    member(NombreCompleto, Pasajeros).

calcularMonto(factura(_, hotel(_, ImportePagado)), MontoFactura):-
    MontoFactura is ImportePagado * 0.5.

calcularMonto(factura(_, vuelo(NroVuelo, _)), Monto):-
    registroVuelo(NroVuelo, Destino, _ , _, Valor),
    Destino \= buenosAires,
    Monto is Valor * 0.3.

calcularMonto(factura(_, vuelo(NroVuelo, _)), Monto):-
    registroVuelo(NroVuelo, Destino, _ , _, _),
    Destino = buenosAires,
    Monto is 0.

calcularMonto(factura(_, excursion(_, Precio, CantPersonas)), Monto):-
    Monto is (Precio / CantPersonas) * 0.8.

ciudadesVisitas(Facturas, CantCiudades):-
    findall(Ciudad, (member(Factura, Facturas), ciudadFactura(Factura, Ciudad)), Ciudades),
    list_to_set(Ciudades, CiudadesSinDuplicar),
    length(CiudadesSinDuplicar, CantCiudades).

ciudadFactura(factura(_, hotel(Hotel, _)), Ciudad):-
    comercioAdherido(Ciudad, Hotel).

ciudadFactura(factura(_, excursion(Excursion, _, _)), Ciudad):-
    comercioAdherido(Ciudad, Excursion).

agregarPenalidad(Facturas, MontoIntermedio, MontoFinal):-
    member(Factura, Facturas),
    esValida(Factura), 
    MontoFinal is MontoIntermedio.

agregarPenalidad(Facturas, MontoIntermedio, MontoFinal):-
    member(Factura, Facturas),
    not(esValida(Factura)),
    MontoFinal is MontoIntermedio - 15000.

montoMax(MontoIntermedio, MontoFinal):-
    MontoFinal is min(MontoIntermedio, 100000).

%%%%%%%%%%%%%%%%%%%% Punto 2

destinosTrabajo(Destinos):-
    findall(Destino, destinoTrabajo(Destino), Destinos).

destinoTrabajo(Destino):-
    registroVuelo(_, Destino, _, Pasajeros, _),
    forall(member(Pasajero, Pasajeros), not(esTurista(Pasajero))).

destinoTrabajo(Destino):-
    comercioAdherido(Destino, Comercio1),
    factura(_, hotel(Comercio1, _)),
    not((comercioAdherido(Destino, Comercio2), Comercio2 \= Comercio1, factura(_, hotel(Comercio2, _)))).

esTurista(Pasajero):-
    factura(NombrePasajero, vuelo(_, Pasajero)),
    factura(NombrePasajero, hotel(_, _)),
    factura(NombrePasajero, excursion(_, _, _)).

%%%%%%%%%%%%%%%%%%%% Punto 3

sonEstafadores(Personas):-
    findall(Persona, esEstafador(Persona), Personas).

esEstafador(Persona):-
    factura(Persona, _),
    forall(factura(Persona, Factura), not(esValida(Factura))).

esEstafador(Persona):-
    factura(Persona, hotel(_, Monto)),
    Monto = 0.

esEstafador(Persona):-
    factura(Persona,excursion(_, Monto, _)), 
    Monto = 0.

%%%%%%%%%%%%%%%%%%%% Punto 4

% Ejemplo de cómo agregar un nuevo tipo de comercio adherido: restaurant.
% Aquí agregamos un restaurant y su lógica para calcular el monto a devolver

comercioAdherido(buenosAires, restauranteLaParrilla).

factura(sofia, comida(restauranteLaParrilla, 3000)).
factura(sofia, comida(restauranteLaParrilla, 0)).

calcularMonto(comida(_, ImportePagado), MontoFactura):-
    MontoFactura is ImportePagado * 0.2.

% Este ejemplo demuestra cómo añadir un nuevo tipo de comercio (restaurant) sin modificar 
% el resto del código. Esto es posible porque el código está acoplado de manera débil, 
% lo que permite extensibilidad sin necesidad de cambios significativos.

%%%%%%%%%%%%%%%%%%%% Punto 5

comercioAdherido(marDelPlata, hotelLasArenas).
comercioAdherido(bariloche, hikingCerroOtto).

factura(martina, hotel(hotelLasArenas, 100)).
factura(pedro, excursion(hikingCerroOtto, 20000, 10)).
factura(miriam, excursion(hikingCerroOtto, 10000, 5)).










    
