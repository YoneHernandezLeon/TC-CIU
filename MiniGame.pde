abstract class MiniGame {
  int score = 0;
  boolean start = false;
  String gameName = "";
  
  
  /*
  Este metodo se encarga de gestionar que se muestre el juego o las instrucciones.
  
  Gestion basica usando el parametro start
    start = false -> howToPlay()
    start = true -> inGame()
  
  */
  abstract void display();
  
  
  /*
  Este metodo muestra las instrucciones
  */
  abstract void howToPlay();
  
  
  /*
  Este metodo muestra y gestiona todo el juego como tal
  */
  abstract void inGame();
  
  
  /**
  Este metodo retorna la puntuacion actual
  
  Devuelve:
    int score: Puntuacion del juego
  */
  int getScore(){
    return score;
  }
  
  
  
  /**
  Este metodo retorna el nombre del juego
  
  Devuelve:
    String gameName: Nombre del juego
  */
  String getGameName(){
    return gameName;
  }
  
  
  /*
  Este metodo se encarga de mostrar por pantalla una cuenta atras de 3 segundos antes de comenzar el juego
  */
  void countDown(){
    background(255);
    textSize(50);
    text("3",400,400);
    delay(1000);
    background(255);
    text("2",400,400);
    delay(1000);
    background(255);
    text("1",400,400);
    delay(1000);
    background(255);
    text("YA",400,400);
    delay(100);
    background(255);
  }
  
  
  /*
  Este metodo se encarga de recibir la tecla pulsada para su gestion apropiada
  
  Gestion usando el parametro start:
    Cuando se pulse por primera vez ENTER se pondra start=true y se llama a countDown
  
  
  Parametros:
    int keyPress: La tecla pulsada
  */
  abstract void control(int keyPress);
  
  
  /*
  Este metodo se encarga de recibir las coordenadas del raton y un booleano indicando que tipo de click se recibe (izquierod o derecho)
  
  Parametros:
    int x: Posicion x del raton
    int y: Posicion y del raton
    boolean left: Sera true cuando se produzca un click izquierdo y false cuando se produzca un click derecho
  */
  abstract void control(int x, int y, boolean left);
}
