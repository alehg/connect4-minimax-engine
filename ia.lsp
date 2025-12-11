;funcion principal

(defun main()
	
	(OPEN-OUTPUT-FILE 'salida.txt T)
	(reclaim)
	(inicializa)

;cargas la dificultad y el estado actual del juego
	(load 'dif.txt)
	(load 'estado.txt)
	(setq nivel (+ 1 dificult)) ;niveles 1, 2 o 3

	(podaAB '(1 0 0 -1 -50000 50000 T))
	(PRINT decision *OUTPUT-FILE*)
	(CLOSE-OUTPUT-FILE 'salida.txt)
)

;inicializa las variables a utilizar
(defun inicializa()
	(setq dificult 0)
	;(setq estado '((0 3 3 3 3 3) (0 3 3 3 3 3) (0 3 3 3 3 3) (0 3 3 3 3 3) (0 3 3 3 3 3) (0 3 3 3 3 3) (0 3 3 3 3 3)))
	(setq nivel 2)
	(setq decision -1)
	(setq cerrado nil)
	(setq contador 1)
)

;metodo de la poda alfa beta (variante del minimax)
(defun podaAB(nodo)
	(setq maximo (getvalor nodo))

	;va a tomar la decision de la jugada
	(tomadecision (getsucesores nodo) maximo)
	
)

;realmente aqui se hace la poda alfabeta. regresa el valor del nodo, dado por ab pruning
(defun getvalor(nodo)	
	(push nodo cerrado)
	
	(setq edonodo (creaestado nodo))
	((eq nivel (caddr nodo))
		;evaluar el nodo
		(setq evaa (evalua nodo))
		
		(((integerp (/ (caddr nodo) 2))
			(setq arev 4))
		(setq arev 5))

		(setq nodo
			(append (reverse (nthcdr (- 7 arev) (reverse nodo)))
			(list evaa)
			(nthcdr (add1 arev) nodo))
		)
		(modcerrado nodo)
		
		evaa
	)

	(setq g (alguiengano nodo))
	((not (zerop g))
		
		(((integerp (/ (caddr nodo) 2))
			(setq arev 4))
		(setq arev 5))

		(setq nodo
			(append (reverse (nthcdr (- 7 arev) (reverse nodo)))
			(list (* g 50000))
			(nthcdr (add1 arev) nodo))
		)

		(modcerrado nodo)
		(* g 50000)
	)

	((empate nodo)
		(((integerp (/ (caddr nodo) 2))
			(setq arev 4))
		(setq arev 5))

		(setq nodo
			(append (reverse (nthcdr (- 7 arev) (reverse nodo)))
			(list 0)
			(nthcdr (add1 arev) nodo))
		)
					
		(modcerrado nodo)
		0
	)
	

	;expandir (aqui ya viene alfabeta)
	((car (reverse nodo))
		(maxvalor nodo)
	)
	
	(minvalor nodo)
	
	
	
)

;metodo auxiliar del ab pruning
(defun maxvalor(nodo)
	(maxvaux nodo 0 (reverse (cdddr (reverse nodo)))  (nthcdr 5 nodo))
)

;metodo auxiliar del ab pruning
(defun maxvaux(nd jugada infant infdesp)
	((eq jugada 7) (modcerrado nd) (car (cddddr nd)))
	(setq edonodo (creaestado nd))
	
	
	((zerop (count 0 (car (nthcdr jugada edonodo))))
		
		(maxvaux nd (incq jugada) infant infdesp)
	)
	
	(setq nd
		(append infant
		(list 
		   (max (car (cddddr nd)) 
			(getvalor (list (incq contador) (car nd) (add1 (caddr nd)) 
				jugada (car (cddddr nd)) (car (nthcdr 5 nd)) nil))
		   )
		)
		infdesp)
	)
	

	((<= (car (nthcdr 5 nd)) (car (cddddr nd)))
		(maxvaux nd 7 nil nil)
	)
	(maxvaux nd (incq jugada) infant infdesp)

)

;metodo auxiliar del ab pruning
(defun minvalor(nodo)
	
	(minvaux nodo 0 (reverse (cddr (reverse nodo)))  (nthcdr 6 nodo))
)

;metodo auxiliar del ab pruning
(defun minvaux(nd jugada infant infdesp)
	((eq jugada 7)  (modcerrado nd) (car (nthcdr 5 nd)))
	(setq edonodo (creaestado nd))

	((zerop (count 0 (car (nthcdr jugada edonodo))))
		(minvaux nd (incq jugada) infant infdesp)
	)


	(setq nd
		(append infant
		(list 
		   (min (car (nthcdr 5 nd)) 
			(getvalor (list (incq contador) (car nd) (add1 (caddr nd)) 
				jugada (car (cddddr nd)) (car (nthcdr 5 nd)) nil))
		   )
		)
		infdesp)
	)

	((<= (car (nthcdr 5 nd)) (car (cddddr nd)))
		(minvaux nd 7 nil nil)
	)
	(minvaux nd (incq jugada) infant infdesp)

)


;te da los sucesores de un nodo dado, que ya esten en la lista cerrado
(defun getsucesores(nodo)
	(sublista cerrado (car nodo) 1)
)

;dada una lista de nodos, te regresa una sublista con solo los nodos que tienen el valor n en la posicion m
(defun sublista(lista n m)
	(setq sl nil)
	(sublistaaux lista n m sl)
)

(defun sublistaaux(lista n m sub)
	((null lista) sub)
	(((eq n (car (nthcdr m (car lista))))
		(push (car lista) sub)
	))
	(sublistaaux (cdr lista) n m sub)
)

;asigna a decision la jugada de la computadora a realizar

(defun tomadecision(lista n)
	
	(setq decision (cadddr (car (sublista lista n 5))))
)


;actualiza la lista cerrado con el nodo dado (ya existia ese nodo en cerrado, pero lo va a actualizar)
(defun modcerrado(nodo)
	(setq subl (sublista cerrado (car nodo) 0))
	(setq pos (position (car subl) cerrado 'equal))
	(setq cerrado (append 
			(reverse (nthcdr (- (length cerrado) pos) (reverse cerrado)))
			(list nodo)
			(nthcdr (add1 pos) cerrado)
		      )
	)

)

;revisa si alguien gano. +1 si gano compu, -1 si gano usuario, 0 si no ha ganado nadie
(defun alguiengano(nd)
	
	(setq ga 0)
	(setq fil 0)
	(loop ;revisa si gano horizontalmente
		((eq fil 6))
		(setq col 0)
		(loop
			((eq col 4))

			(setq cuatro
	
			(list 
			    (car (nthcdr fil (car (nthcdr col edonodo))))
			    (car (nthcdr fil (car (nthcdr (add1 col) edonodo))))
			    (car (nthcdr fil (car (nthcdr (+ 2 col) edonodo))))
			    (car (nthcdr fil (car (nthcdr (+ 3 col) edonodo))))
			))
		
			(setq cuno (count 1 cuatro) cdos (count 2 cuatro))
			
			((eq 4 cuno))
			((eq 4 cdos))


			(incq col)
		)
		
		((eq 4 cuno) (setq ga -1))
		((eq 4 cdos) (setq ga 1))
		
		(incq fil)
	)

	(((zerop ga);solo si aun no se ha visto una linea ganadora, hay que seguir revisando
	   (setq fil 0)
	   (loop ;revisa si gano verticalmente
		((eq fil 3))
		(setq col 0)
		(loop
			((eq col 7))
			
			(setq cuatro
	
			(list 
			    (car (nthcdr fil (car (nthcdr col edonodo))))
			    (car (nthcdr (add1 fil) (car (nthcdr col edonodo))))
			    (car (nthcdr ( + 2 fil) (car (nthcdr col edonodo))))
			    (car (nthcdr ( + 3 fil) (car (nthcdr col edonodo))))
			))
		
			(setq cuno (count 1 cuatro) cdos (count 2 cuatro))
			
			
			((eq 4 cuno))
			((eq 4 cdos))

			(incq col)
		)
		
		((eq 4 cuno) (setq ga -1))
		((eq 4 cdos) (setq ga 1))
		
		(incq fil)
	   )
	));cierra (zerop ga) junto con tercer parentesis

	

	(((zerop ga);solo si aun no se ha visto una linea ganadora, hay que seguir revisando
	   (setq fil 0)
	   (loop ;revisa si gano diagonal positiva
		((eq fil 3))
		(setq col 0)
		(loop
			((eq col 4))
			
			(setq cuatro
	
			(list 
			    (car (nthcdr fil (car (nthcdr col edonodo))))
			    (car (nthcdr (add1 fil) (car (nthcdr (add1 col) edonodo))))
			    (car (nthcdr ( + 2 fil) (car (nthcdr (+ 2 col) edonodo))))
			    (car (nthcdr ( + 3 fil) (car (nthcdr (+ 3 col) edonodo))))
			))
		
			(setq cuno (count 1 cuatro) cdos (count 2 cuatro))
			
			
			((eq 4 cuno))
			((eq 4 cdos))

			(incq col)
		)
		
		((eq 4 cuno) (setq ga -1))
		((eq 4 cdos) (setq ga 1))
		
		(incq fil)
	   )
	));cierra (zerop ga) junto con tercer parentesis


	(((zerop ga);solo si aun no se ha visto una linea ganadora, hay que seguir revisando
	   (setq fil 3)
	   (loop ;revisa si gano diagonal negativa
		((eq fil 6))
		(setq col 0)
		(loop
			((eq col 4))
			
			(setq cuatro
	
			(list 
			    (car (nthcdr fil (car (nthcdr col edonodo))))
			    (car (nthcdr (sub1 fil) (car (nthcdr (add1 col) edonodo))))
			    (car (nthcdr (- fil 2) (car (nthcdr (+ 2 col) edonodo))))
			    (car (nthcdr (- fil 3) (car (nthcdr (+ 3 col) edonodo))))
			))
		
			(setq cuno (count 1 cuatro) cdos (count 2 cuatro))
			
			
			((eq 4 cuno))
			((eq 4 cdos))

			(incq col)
		)
		
		((eq 4 cuno) (setq ga -1))
		((eq 4 cdos) (setq ga 1))
		
		(incq fil)
	   )
	));cierra (zerop ga) junto con tercer parentesis


	ga
)


;metodo que evalua un nodo de acuerdo a la funcion heuristica
;el codigo aqui es algo repetitivo
(defun evalua (nodo)
	(setq eva 0)


	(setq fil 0)
	(loop ;lineas horizontales
		((eq fil 6))
		(setq col 0)
		(loop
			((eq col 4))
			
			(setq cuatro
	
			(list 
			    (car (nthcdr fil (car (nthcdr col edonodo))))
			    (car (nthcdr fil (car (nthcdr (add1 col) edonodo))))
			    (car (nthcdr fil (car (nthcdr (+ 2 col) edonodo))))
			    (car (nthcdr fil (car (nthcdr (+ 3 col) edonodo))))
			))
		
			(setq cuno (count 1 cuatro) cdos (count 2 cuatro))
			(setq ccero (count 0 cuatro) ctres (count 3 cuatro))
			(setq vacio (+ ccero ctres))

			((eq 4 cuno) (setq eva -50000))
			((eq 4 cdos) (setq eva  50000))
			

			(((eq 4 vacio))
			 (((plusp vacio)
			
				((   (and (eq 1 cuno) (eq 3 vacio))    (decq eva 1)  )

				 (   (and (eq 2 cuno) (eq 2 ccero))    (decq eva 12)  )
				 (   (and (eq 2 cuno) (eq 1 ccero) (eq 1 ctres))    (decq eva 8)  )
				 (   (and (eq 2 cuno) (eq 2 ctres))    (decq eva 4)  )

				 (   (and (eq 3 cuno) (eq 1 ccero))    
							(((null (car (reverse nodo))) (decq eva 300))
							(decq eva 50)) 
				 )

				 (   (and (eq 3 cuno) (eq 1 ctres))    (decq eva 20) )



				 (   (and (eq 1 cdos) (eq 3 vacio))    (incq eva 1)  )

				 (   (and (eq 2 cdos) (eq 2 ccero))    (incq eva 12)  )
				 (   (and (eq 2 cdos) (eq 1 ccero) (eq 1 ctres))    (incq eva 8)  )
				 (   (and (eq 2 cdos) (eq 2 ctres))    (incq eva 4)  )

				 (   (and (eq 3 cdos) (eq 1 ccero))    
							(((car (reverse nodo)) (incq eva 300))
							(incq eva 50)) 
				 )

				 (   (and (eq 3 cdos) (eq 1 ctres))    (incq eva 20) )


				)
			
			)))
			
			(incq col)
		)
		
		
		
		(incq fil)
	)

	(setq fil 0)
	(loop ;lineas verticales
		((eq fil 3))
		(setq col 0)
		(loop
			((eq col 7))
			
			(setq cuatro
	
			(list 
			    (car (nthcdr fil (car (nthcdr col edonodo))))
			    (car (nthcdr ( add1 fil) (car (nthcdr col edonodo))))
			    (car (nthcdr ( + 2 fil) (car (nthcdr col edonodo))))
			    (car (nthcdr ( + 3 fil) (car (nthcdr col edonodo))))
			))
		
			(setq cuno (count 1 cuatro) cdos (count 2 cuatro))
			(setq ccero (count 0 cuatro) ctres (count 3 cuatro))
			(setq vacio (+ ccero ctres))

			((eq 4 cuno) (setq eva -50000))
			((eq 4 cdos) (setq eva  50000))
			

			(((eq 4 vacio))
			 (((plusp vacio)
			
				((   (and (eq 1 cuno) (eq 3 vacio))    (decq eva 1)  )

				 (   (and (eq 2 cuno) (eq 2 ccero))    (decq eva 12)  )
				 (   (and (eq 2 cuno) (eq 1 ccero) (eq 1 ctres))    (decq eva 8)  )
				 (   (and (eq 2 cuno) (eq 2 ctres))    (decq eva 4)  )

				 (   (and (eq 3 cuno) (eq 1 ccero))    
							(((null (car (reverse nodo))) (decq eva 300))
							(decq eva 50)) 
				 )

				 (   (and (eq 3 cuno) (eq 1 ctres))    (decq eva 20) )



				 (   (and (eq 1 cdos) (eq 3 vacio))    (incq eva 1)  )

				 (   (and (eq 2 cdos) (eq 2 ccero))    (incq eva 12)  )
				 (   (and (eq 2 cdos) (eq 1 ccero) (eq 1 ctres))    (incq eva 8)  )
				 (   (and (eq 2 cdos) (eq 2 ctres))    (incq eva 4)  )

				 (   (and (eq 3 cdos) (eq 1 ccero))    
							(((car (reverse nodo)) (incq eva 300))
							(incq eva 50)) 
				 )

				 (   (and (eq 3 cdos) (eq 1 ctres))    (incq eva 20) )


				)
			
			)))
	
			(incq col)
		)
		
		
		
		(incq fil)
	)

	
	
	(setq fil 0)
	(loop ;lineas diagonales positivas
		((eq fil 3))
		(setq col 0)
		(loop
			((eq col 4))
			
			(setq cuatro
	
			(list 
			    (car (nthcdr fil (car (nthcdr col edonodo))))
			    (car (nthcdr (add1 fil) (car (nthcdr (add1 col) edonodo))))
			    (car (nthcdr ( + 2 fil) (car (nthcdr (+ 2 col) edonodo))))
			    (car (nthcdr ( + 3 fil) (car (nthcdr (+ 3 col) edonodo))))
			))
		
			(setq cuno (count 1 cuatro) cdos (count 2 cuatro))
			(setq ccero (count 0 cuatro) ctres (count 3 cuatro))
			(setq vacio (+ ccero ctres))

			((eq 4 cuno) (setq eva -50000))
			((eq 4 cdos) (setq eva  50000))
			

			(((eq 4 vacio))
			 (((plusp vacio)
			
				((   (and (eq 1 cuno) (eq 3 vacio))    (decq eva 1)  )

				 (   (and (eq 2 cuno) (eq 2 ccero))    (decq eva 12)  )
				 (   (and (eq 2 cuno) (eq 1 ccero) (eq 1 ctres))    (decq eva 8)  )
				 (   (and (eq 2 cuno) (eq 2 ctres))    (decq eva 4)  )

				 (   (and (eq 3 cuno) (eq 1 ccero))    
							(((null (car (reverse nodo))) (decq eva 300))
							(decq eva 50)) 
				 )

				 (   (and (eq 3 cuno) (eq 1 ctres))    (decq eva 20) )



				 (   (and (eq 1 cdos) (eq 3 vacio))    (incq eva 1)  )

				 (   (and (eq 2 cdos) (eq 2 ccero))    (incq eva 12)  )
				 (   (and (eq 2 cdos) (eq 1 ccero) (eq 1 ctres))    (incq eva 8)  )
				 (   (and (eq 2 cdos) (eq 2 ctres))    (incq eva 4)  )

				 (   (and (eq 3 cdos) (eq 1 ccero))    
							(((car (reverse nodo)) (incq eva 300))
							(incq eva 50)) 
				 )

				 (   (and (eq 3 cdos) (eq 1 ctres))    (incq eva 20) )


				)
			
			)))
	
			(incq col)
		)
		
		
		
		(incq fil)
	)

	(setq fil 3)
	(loop ;lineas diagonales negativas
		((eq fil 6))
		(setq col 0)
		(loop
			((eq col 4))
			
			(setq cuatro
	
			(list 
			    (car (nthcdr fil (car (nthcdr col edonodo))))
			    (car (nthcdr (sub1 fil) (car (nthcdr (add1 col) edonodo))))
			    (car (nthcdr (- fil 2) (car (nthcdr (+ 2 col) edonodo))))
			    (car (nthcdr (- fil 3) (car (nthcdr (+ 3 col) edonodo))))
			))
		
			(setq cuno (count 1 cuatro) cdos (count 2 cuatro))
			(setq ccero (count 0 cuatro) ctres (count 3 cuatro))
			(setq vacio (+ ccero ctres))

			((eq 4 cuno) (setq eva -50000))
			((eq 4 cdos) (setq eva  50000))
			

			(((eq 4 vacio))
			 (((plusp vacio)
			
				((   (and (eq 1 cuno) (eq 3 vacio))    (decq eva 1)  )

				 (   (and (eq 2 cuno) (eq 2 ccero))    (decq eva 12)  )
				 (   (and (eq 2 cuno) (eq 1 ccero) (eq 1 ctres))    (decq eva 8)  )
				 (   (and (eq 2 cuno) (eq 2 ctres))    (decq eva 4)  )

				 (   (and (eq 3 cuno) (eq 1 ccero))    
							(((null (car (reverse nodo))) (decq eva 300))
							(decq eva 50)) 
				 )

				 (   (and (eq 3 cuno) (eq 1 ctres))    (decq eva 20) )



				 (   (and (eq 1 cdos) (eq 3 vacio))    (incq eva 1)  )

				 (   (and (eq 2 cdos) (eq 2 ccero))    (incq eva 12)  )
				 (   (and (eq 2 cdos) (eq 1 ccero) (eq 1 ctres))    (incq eva 8)  )
				 (   (and (eq 2 cdos) (eq 2 ctres))    (incq eva 4)  )

				 (   (and (eq 3 cdos) (eq 1 ccero))    
							(((car (reverse nodo)) (incq eva 300))
							(incq eva 50)) 
				 )

				 (   (and (eq 3 cdos) (eq 1 ctres))    (incq eva 20) )


				)
			
			)))
	
			(incq col)
		)
		
		
		
		(incq fil)
	)

	eva ;regresa "eva"
	
)



;revisa si el nodo actual es un juego empatado. regresa T o nil, segun el caso
(defun empate(nodo)
	(setq espacios
	   ( + 
		(count 0 (car edonodo))
		(count 0 (cadr edonodo))
		(count 0 (caddr edonodo))
		(count 0 (cadddr edonodo))
		(count 0 (car (cddddr edonodo)))
		(count 0 (car (nthcdr 5 edonodo)))
		(count 0 (car (nthcdr 6 edonodo)))
	   )
	)
	
	((zerop espacios) T)
	nil
)

;dado un nodo, regresa su estado (el tablero completo)
(defun creaestado(nd)
	(setq ms nil)
	
	(loop
		((zerop (cadr nd)))
		(push (cadddr nd) ms)
		(setq nd (car(sublista cerrado (cadr nd) 0)) )
	)

	
	(aplmovsaux estado ms 2)
)

(defun aplmovsaux(edo movim turno)
	
	(loop
		((null movim) edo)
		(((eq turno 3) (setq turno 1)))
		(setq edo (juega (car movim) edo turno))
		(setq movim (cdr movim))
		(incq turno)
	)
)

;metodo que juega una ficha en una columna
(defun juega(m edo turno)
	
	(setq colsdes (nthcdr (add1 m) edo))
	(setq colmov (car (nthcdr m edo)))
	(setq colsant (reverse (nthcdr (- 7 m) (reverse edo))))
	(append colsant (list (juegacol colmov turno)) colsdes)
)


(defun juegacol(columna turno)
	
	(setq pos (position 0 columna))
	(setq coll (append (reverse (nthcdr (- 6 pos) (reverse columna))) (list turno) (nthcdr (add1 pos) columna)))
	((plusp (count 3 coll))
		(append (reverse (nthcdr (- 5 pos) (reverse coll))) (list '0) (nthcdr (+ 2 pos) coll))
	)
	coll
)



(main) ;manda a llamar al main
(system)