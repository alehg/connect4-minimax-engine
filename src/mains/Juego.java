/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package mains;

//todo lo que hay que importar para que funcione :)
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import java.io.*;
import java.util.Scanner;

/**
 *
 * @authors Juan Pablo, Alejandro, Daniel
 */
public class Juego {//La clase se llama Juego
        
        public static void main(String[] args) {//el main solo inicializa el Juego
       javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                            Juego connect4 = new Juego();
                }
        });   
	}
        
	JFrame frame;
	JPanel panel;
        // Juego de conecta 4 con 6 filas y 7 columnas.
	final int filas = 6;
	final int columnas = 7;
	static int[][] edoJuego = new int[6][7]; //arreglo que guarda el tablero
        
        // Variables para guardar datos del juego.
	int fil, col, filSelecc, colSelecc = 0;
	int turno = 0; //turno del juego
	boolean gano = false;
        boolean empate=false;
	JButton[][] casillas = new JButton[filas][columnas]; //arreglo con botones
        int cantGanoJug1=0;
        int cantGanoJug2=0;
        //Nivel seleccionado, del 0 al 2.
        int nivelDificultad= 0;
        // Variables del frame.
        JButton reiniciarJuego;
	JLabel informacion;
        JLabel ganadosJug1;
        JLabel ganadosJug2;
	GridLayout cuadricula = new GridLayout(7,7);
        
	// Imagenes para la interfaz del juego.
	final ImageIcon huecoVacio = new ImageIcon("vacia.jpg");
        // El jugador uno es fichas verdes y usamos un "1" para identificarlo. En los turnos, es el %2==0)
	final ImageIcon fichaVerde = new ImageIcon("verde.jpg");
        // El jugador dos es fichas naranjas y usamos un "2" para identificarlo.   (En los turnos es el %2==1)
	final ImageIcon fichaNaranja = new ImageIcon("naranja.jpg");

        
        
        // Inicializa la interfaz.
	public Juego() {
		frame = new JFrame("Conecta Cuatro");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		panel = new JPanel();
		panel.setLayout(cuadricula);
		informacion = new JLabel("");
                ganadosJug1 = new JLabel("Jug. Uno: "+cantGanoJug1);
                ganadosJug2= new JLabel("Jug. Dos: "+cantGanoJug2);
                reiniciarJuego = new JButton("Reiniciar");
		reiniciarJuego.setPreferredSize(new Dimension(10,10));
                reiniciarJuego.addActionListener(new Juego.ReiniciarJuegoListener());
                
                // Action Listeners para cada casilla del tablero. 
                for (fil = 0; fil <= filas - 1; fil++) {
			for (col = 0; col <= columnas - 1; col++) {
				casillas[fil][col] = new JButton(huecoVacio);
				casillas[fil][col].addActionListener(new Juego.buttonListener());
				panel.add(casillas[fil][col]);
			}
		}
		// Se marcan con 0 las casillas que se pueden llenar (son las de hasta abajo o tienen una ficha debajo de ellas).
		// Se marcan con -1 las casillas en las que no se puede poner una ficha (por que no son las de hasta abajo o no tienen una ficha abajo).
                
                //en el caso de las filas el for es hasta -2 porque solo activamos la primera fila.
		for (int x = filas - 2; x >= 0; x--) {
			for (int y = columnas - 1; y >= 0; y--) {
				edoJuego[x][y] = -1;
			}
		}
                
                // Hasta abajo, botones y quien es el ganador.
                panel.add(informacion);
                panel.add(reiniciarJuego);
                panel.add(ganadosJug1);
                panel.add(ganadosJug2);
		frame.setContentPane(panel);
		frame.pack();
		frame.setVisible(true);
                nivelDificultad = JOptionPane.showOptionDialog(frame, "Escoja un nivel", "Nivel", JOptionPane.YES_NO_CANCEL_OPTION,JOptionPane.QUESTION_MESSAGE, null, new Object[]{"Principiante", "Intermedio", "Profesional"},null);
                
                //escribe la dificultad en un .txt
                escribeDificultad();
                
              
	}
        
        public void escribeDificultad(){
            // Escribimos en un txt el nivelDificultad seleccionado.
            // Es para que la compu "sepa" que tan "buena" tiene que ser.
                FileWriter escribe = null;
                PrintWriter print = null;
                try
                {
                   escribe = new FileWriter("dif.txt");
                    print = new PrintWriter(escribe);

                    //escribimos la dificultad de manera que Lisp entienda
                        print.println("(setq dificult " + nivelDificultad + ")");

                } catch (Exception a) {
                    a.printStackTrace();
                } finally {
                   try {
                 
                   if (null != escribe)
                      escribe.close();
                   } catch (Exception a2) {
                      a2.printStackTrace();
                   }
                }
        }
        
        //Lee la casilla que decide jugar la computadora
        public int leeCasilla(){
            String linea="0";
            File archivo = null;
            FileReader filer = null;
            BufferedReader bufr = null;
            int l=0;

          try {
                archivo = new File ("salida.txt");
                filer = new FileReader (archivo);
                bufr = new BufferedReader(filer);

                // Lectura de la jugada, desde el archivo de texto salida.txt
                linea=bufr.readLine();
               // Solo es un numero del 0 al 6, que representa la columna
                //en que tira la computadora
          }
          catch(Exception a){
             a.printStackTrace();
          }finally{
             try{                    
                if( null != filer ){   
                   filer.close();     
                }                  
             }catch (Exception a2){ 
                a2.printStackTrace();
             }
          }  
          try{
              //intenta convertir a numero la lectura del archivo de texto
              //(siempre se deberia de poder)
              l=Integer.parseInt(linea);
          }
          catch(NumberFormatException e){}
            return l;
        }
        
 //actualiza el tablero actual de juego, en un archivo de texto llamado estado.txt
       public void actualizaEstado(){
           FileWriter tableroActual = null;
                PrintWriter printwr = null;
                try
                {
                    tableroActual = new FileWriter("estado.txt");
                    printwr = new PrintWriter(tableroActual);

                    //se escribe en un formato que Lisp entienda
                        printwr.print("(setq estado '(");
                        for(col=0;col<columnas;col++){
                            printwr.print("(");
                            fil=filas-1;
                            while(fil>=0){
                                if(edoJuego[fil][col] != -1){
                                    printwr.print(edoJuego[fil][col] + " ");
                                }
                                else{
                                    printwr.print("3 ");//Lisp trabaja con 3 en lugar de -1
                                }
                                fil--;
                            }
                            
                            printwr.print(") ");
                        }
                        printwr.println("))");
                        
                } catch (Exception a) {
                    a.printStackTrace();
                } finally {
                   try {
                 
                   if (null != tableroActual)
                      tableroActual.close();
                   } catch (Exception a2) {
                      a2.printStackTrace();
                   }
                }
       }
                
        // Clase para llenar el tablero con las fichas al dar clic en algun boton.
	class buttonListener implements ActionListener {
                @Override
		public void actionPerformed(ActionEvent event) {
                    //"siente" que un botón se apreto
                    //entonces, revisa de donde vino esa sensacion
                    
			for (fil = filas-1; fil >= 0; fil--) {
				for (col = columnas-1; col >= 0; col--) {
                                    
                                    //es decir, revisa cual boton fue apretado
					if (casillas[fil][col] == event.getSource()) {
                                            // Jugador 1.
                                            boolean t=false;
						if (turno % 2 == 0 && edoJuego[fil][col] == 0) {
                                                    t=true;//"t" indica si sigue el juego
							casillas[fil][col].setIcon(fichaVerde);//se coloca la ficha
							edoJuego[fil][col] = 1;
                                                        // Try y catch por si se sale de los limites (no deberia de pasar)
							try {
								edoJuego[fil-1][col] = 0;
							}
							catch (ArrayIndexOutOfBoundsException e) {
								System.out.println("Error, se alcanzo el tope");
							}
                                                        
                                                        // Revisa si hay un ganador(despues de al menos 4 turnos del jugador 1), imprime el mensaje y bloquea el tablero.
							if (turno>=6 && revisa()) {
                                                                JOptionPane.showMessageDialog(null,"El jugador uno ganó!");
								informacion.setText("El J1 ganó!");
                                                                cantGanoJug1++;
                                                                ganadosJug1.setText("Jug. Uno: "+cantGanoJug1);
								for (int x = filas - 1; x >=0; x--) {
									for (int y = columnas - 1; y >= 0; y--) {
                                                                            //bloquea el tablero
										edoJuego[x][y] = -1;
									}
								}
                                                                
                                                                t=false;//ya acabó este juego
							}
                                                        
                                                        //Avisa de empate, imprime el mensaje y bloquea el tablero.
                                                        if(empate==true){
                                                                JOptionPane.showMessageDialog(null,"Ha habido un empate!");
								informacion.setText("Empate!");
								for (int x = filas - 1; x >=0; x--) {
									for (int y = columnas - 1; y >= 0; y--) {
										edoJuego[x][y] = -1;
									}
								}
                                                                t=false;
                                                        }
                                                        
                                                        //se actualiza el estado
                                                        actualizaEstado();
                                                        
                                                        // El sumador de turnos nos permite saber a quien le toca.
							turno = turno + 1;
						}
                                                
                                                //Luego, viene el turno de la computadora!!
                                                //La computadora toma su decision en otro codigo escrito en Lisp
                                                //El siguiente codigo llama a ejecutar Lisp.
                                                //La computadora sabe del juego gracias a los textos "estado.txt" y "dif.txt"
                                              
                                                if(t){// "t" sólo indica si sigue el juego
                                                try{
                                                    Runtime r = Runtime.getRuntime();
                                                    Process p =r.exec("cmd /c mulisp ia");
                                                    OutputStream out = p.getOutputStream();
                                                    out.write("mulisp /r/n".getBytes());
                                                    out.close();
                                                    p.waitFor();
                                                }
                                                 catch(IOException e1) {
                                                System.out.println("e1");
                                                }
                                                catch(InterruptedException e2) {
                                                    System.out.println("e2");
                                                }
                                                
                                                //Nos esperamos un momento:
                                                try {
                                                    Thread.sleep(100);
                                                } catch(InterruptedException ex) {
                                                    Thread.currentThread().interrupt();
                                                }
                                                //Listo, ya termino Lisp.
                                                
                                                //veamos que decidio hacer la compu:
                                                    int columna=leeCasilla();
                                                    int fila=0;
                                                    //escoge una columna
                                                    //hay que ver a que altura se va a poner la ficha:
                                                    while(fila<6&&edoJuego[fila][columna]!=0)
                                                        fila++;
                                                    col=columna;
                                                    fil=fila;
                                                    
                                                    
                                                    // Por si hay errores (no deberia); se revisan aqui
                                                    if(fil>=6||col>=7){
                                                         JOptionPane.showMessageDialog(null,"Casilla inválida");
                                                            informacion.setText("Casilla inválida");
                                                            col=0;
                                                            fil=0;
                                                            break;
                                                    }
                                                     
                                                // Ahora se procede a actualizar el tablero y el edoJuego
						if (turno % 2 == 1 && edoJuego[fil][col] == 0) {
                                                    
							casillas[fil][col].setIcon(fichaNaranja); 
							edoJuego[fil][col] = 2;
                                                        
                                                        // Try y catch por cualquier cosa
							try {
								edoJuego[fil-1][col] = 0;
							}
							catch (ArrayIndexOutOfBoundsException e) {
								System.out.println("Error, se alcanzo el tope");
							}
                                                        
                                                        // Revisa si gano el jugador 2 (computadora), imprime el mensaje y bloquea el tablero.
							if (turno>=6 && revisa()) {
								
                                                                JOptionPane.showMessageDialog(null,"El jugador dos ganó!");
								informacion.setText("El J2 ganó!");
                                                                cantGanoJug2++;
                                                                ganadosJug2.setText("Jug. Dos: "+cantGanoJug2);
								for (int x = filas - 1; x >=0; x--) {
									for (int y = columnas - 1; y >= 0; y--) {
										edoJuego[x][y] = -1;
									}
								}
							}
                                                         //Avisa de empate, imprime el mensaje y bloquea el tablero.
                                                        if(empate==true){
                                                                JOptionPane.showMessageDialog(null,"Ha habido un empate!");
								informacion.setText("Empate!");
								for (int x = filas - 1; x >=0; x--) {
									for (int y = columnas - 1; y >= 0; y--) {
										edoJuego[x][y] = -1;
									}
								}
                                                        }
                                                        
                                                        //actualiza el tablero en el .txt
                                                        actualizaEstado();
                                                        
                                                        //aumenta el turno
							turno = turno + 1;
							break;
						}
						else {
                                                        //creo que ya no entra aqui nunca
                                                        if(gano){
                                                            JOptionPane.showMessageDialog(null,"El juego ha terminado, inicie un nuevo juego");
                                                            informacion.setText("El juego ha terminado, inicie un nuevo juego");
                                                        }
                                                        else{
                                                            JOptionPane.showMessageDialog(null,"Seleccione una casilla valida");
                                                            informacion.setText("Seleccione una casilla valida");
                                                        }
                                                            
						}
                                                }
                                                
					}
				}//cierra for interno
			}//cierra for externo
		}//cierra actionPerformed
	}//cierra buttonListener
         
        // Listener del boton reiniciarJuego; escucha si se apreto el boton de reiniciarJuego
        class ReiniciarJuegoListener implements ActionListener {
                @Override
		public void actionPerformed(ActionEvent event) {
                    //vuelve todo a -1 excepto la primera fila.
			for (int x = filas - 1; x >= 0; x--) {
				for (int y = columnas - 1; y >= 0; y--) {
                                    if(x==5)
                                        edoJuego[x][y] = 0;
                                    else
					edoJuego[x][y] = -1;                 
				casillas[x][y].setIcon(huecoVacio);
				}
			}
                       
			// Reinicializa variables
			informacion.setText("");
                        turno=0;
                        gano=false;
                        empate=false;
                        nivelDificultad = JOptionPane.showOptionDialog(frame, "Escoja un nivel", "Nivel", JOptionPane.YES_NO_CANCEL_OPTION,JOptionPane.QUESTION_MESSAGE, null, new Object[]{"Principiante", "Intermedio", "Profesional"},null);
                         
                        //escribe ladificultad en el .txt
                         escribeDificultad();
		}
	}
        // Clase que revisa si gano alguno de los jugadores.
	public boolean revisa() {
        //Para cada uno de los casos posibles para ganar, revisa que no sea cero y que no sea -1. Ademas, revisa que las 4 casillas sean iguales. 
                       
            // Checa si gano vertical
		for (int x=0; x<3; x++) {
			for (int y=0; y<7; y++) {
				if (edoJuego[x][y] != 0 && edoJuego[x][y] != -1 &&
				edoJuego[x][y] == edoJuego[x+1][y] &&
				edoJuego[x][y] == edoJuego[x+2][y] &&
				edoJuego[x][y] == edoJuego[x+3][y]) {
					gano = true;
				}
			}
                }
                
		// Checa si gano horizontal
		for (int x=0; x<6; x++) {
			for (int y=0; y<4; y++) {
				if (edoJuego[x][y] != 0 && edoJuego[x][y] != -1 &&
				edoJuego[x][y] == edoJuego[x][y+1] &&
				edoJuego[x][y] == edoJuego[x][y+2] &&
				edoJuego[x][y] == edoJuego[x][y+3]) {
					gano = true;
				}
			}
		}
		
		// Checa si gano diagonal pendiente positiva
		for (int x=0; x<3; x++) {
			for (int y=0; y<4; y++) {
				if (edoJuego[x][y] != 0 && edoJuego[x][y] != -1 &&
				edoJuego[x][y] == edoJuego[x+1][y+1] &&
				edoJuego[x][y] == edoJuego[x+2][y+2] &&
				edoJuego[x][y] == edoJuego[x+3][y+3]) {
					gano = true;
				}
			}
		}
		// Checa si gano diagonal pendiente negativa
		for (int x=3; x<6; x++) {
			for (int y=0; y<4; y++) {
			if (edoJuego[x][y] != 0 && edoJuego[x][y] != -1 &&
				edoJuego[x][y] == edoJuego[x-1][y+1] &&
				edoJuego[x][y] == edoJuego[x-2][y+2] &&
				edoJuego[x][y] == edoJuego[x-3][y+3]) {
					gano = true;
				}
			}
		}
                // Checa si todo el tablero esta lleno (empatado)
                if(!gano){
                int temp=0;
                for (int x=0; x<6; x++) {
			for (int y=0; y<7; y++) {
				if (edoJuego[x][y] != 0 && edoJuego[x][y] != -1) {
					temp++;
				}
			}
                }
                if(temp==42){
                    empate=true;
                    return false;
                }
                }
		return gano;
	}
}



