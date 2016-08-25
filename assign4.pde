
//GAMESTATES
final int GAME_START    = 0;
final int GAME_RUN      = 1;
final int GAME_LOSE     = 2;

//hpX control
final int FULL      = 1;
final int NOT_FULL  = 2;
final int EMPTY     = 0;

//enemy control
final int Straight  = 1;
final int Slope     = 2;
final int Diamond   = 3; 

PImage enemy ;
PImage fighter ;
PImage hp ;
PImage treasure ;
PImage bg1;
PImage bg2;
PImage end1;
PImage end2;
PImage enemy1;
PImage gainbomb;
PImage start1;
PImage start2; 
float treasureX, treasureY;
float fighterX, fighterY;
float fighterSpeed;
float hpX;
float speed=6;

int width, height;
int x1, x2;

boolean upPressed    = false;
boolean downPressed  = false;
boolean leftPressed  = false;
boolean rightPressed = false;

int numCrash=8;
boolean crash[]=new boolean [numCrash];

//enemy

int numEnemyX=6;
float enemyX[]=new float[numEnemyX];
int numEnemyY=6;
float enemyY[]=new float[numEnemyY];

int numDiamondEnemyX=3;
float enemyDiamondX[]=new float[numDiamondEnemyX];
int numDiamondEnemyY=3;
float enemyDiamondY[]=new float[numDiamondEnemyY];

// flame
float flameX;
float flameY;

//shoot
PImage shoot;
int numFire=5;

float shootX[]=new float [numFire];
float shootY[]=new float [numFire];
int shootCount=-1;
int fire=0;

int currentFlame;
int numFlame=5;
PImage [] flame=new PImage [numFlame];

int count=1;
int hpState = FULL;
int gameState ;
int enemyState = Straight;

void setup () {
  // background
  width = 640;
  height = 480;
  size(640,480);
  x1 = 0;
  x2 = -width;
  //  load images
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  enemy = loadImage("img/enemy.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  shoot=loadImage("img/shoot.png");
  
  image(fighter, fighterX,  fighterY);
  fighterX = 580;
  fighterY = 240;
  fighterSpeed = 5;

  enemyX[0] = -65;
  enemyY[0] = floor(random(60,420));
  
  image(treasure, treasureX,  treasureY);
  treasureX = floor(random(60,580));
  treasureY = floor(random(60,420));
  
  image(hp, hpX, 0);
  hpX = 42; 
  
  gameState = GAME_START;
  enemyState = Straight;
  //flame
  currentFlame=0;
  for(int j=0; j<numFlame; j++){
   flame[j]=loadImage("img/flame"+(j+1)+".png");
  }
 
  frameRate(60);
  
}

void draw() {
  if(0 < hpX  &&  hpX < 210){
    hpState = NOT_FULL;
    }
  if(hpX >= 210){
    hpX = 210;
    hpState = FULL;
    }
  if(hpX <= 0){
    hpState = EMPTY;
    }
  
  switch(hpState){    
      case FULL:
        if( treasureX - 20 <= fighterX + 20  && fighterX + 20 <= treasureX + 55  &&
            treasureY - 25 <= fighterY + 20  && fighterY + 20 <= treasureY + 55){
          treasureX = random(60,580); 
          treasureY = random(60,420);
        }
        break;
      
      case NOT_FULL:
        if(treasureX - 20 <= fighterX + 20  &&  fighterX + 20 <= treasureX + 55  &&
           treasureY - 20 <= fighterY + 20  &&  fighterY + 20 <= treasureY + 55){
         hpX += 210 * 10 / 100;
         treasureX=random(60,580); 
         treasureY=random(60,420);
        }
        break;
      
      case EMPTY:
        gameState=GAME_LOSE;
        break;
  }
  
  switch (gameState){
    case GAME_START:
    image(start2, 0, 0 );
    //mouse action
    if (444 >= mouseX && mouseX >= 213 &&  420 >= mouseY && mouseY >= 381){ 
      image(start1, 0, 0);
    if (mousePressed){
          // click
          gameState = GAME_RUN;
        }
    }
    break;
    
    case GAME_RUN:
    // background
    image( bg2, x1, 0 );
    image( bg1, x2, 0 );
    if( x1 == width )
      x1 = -width;
    else
      x1 += 2;
 
    if( x2 == width )
      x2 = -width;
    else
    x2 += 2;
     // treasure
      image(treasure,treasureX,treasureY);
      // fighter
      image(fighter,fighterX,fighterY);
      // move fighter 
       if (upPressed) {
          fighterY -= fighterSpeed;
        }
       if (downPressed) {
          fighterY += fighterSpeed;
        }
        if (leftPressed) {
          fighterX -= fighterSpeed;
        }
        if (rightPressed) {
          fighterX += fighterSpeed;
        }
     //move fighter(boundary detection)
        if (fighterX > width-50){
          fighterX = width-50; 
        }
        if (fighterX < 0){
           fighterX = 0; 
        }
  
        if (fighterY > height-50){
           fighterY = height-50;
        }
        if (fighterY < 0){
           fighterY = 0;
        }
      // hp
      fill(#ff0000);
      rectMode(CORNERS);
      rect(10,0,hpX,30);
      image(hp,5,0);
      
      //fire

      if(shootCount>=-1){
      for(int i=0; i<numFire; i++){
        shootX[i]-=speed;
        image(shoot,shootX[i],shootY[i]);
   

    }
    if(shootX[0]+31<0.0){
    shootCount--;
    
      }
    }
    
    if(shootCount<-1){
    shootCount=-1;
    }
    
    if(shootCount>4){
    shootCount=4;
    }
      
      // enemy 
      switch(enemyState){
        case Straight:
        
        enemyX[0]+=speed;
        
        for(int i = 1; i < numEnemyX; i++){
          
          enemyX[i]=enemyX[0]-80*i;
          enemyY[i]=enemyY[0];
        
        if(crash[i-1]==false){
        if(fighterX<enemyX[i]+61&&fighterX+51>enemyX[i]&&
           fighterY+51>enemyY[i]&&fighterY<enemyY[i]+61){

      hpX-=42;       
      flameX=enemyX[i];
      flameY=enemyY[i];
    
     if(frameCount%6==0){
      currentFlame++;
       }
     if(currentFlame<5){
     image(flame[currentFlame],flameX,flameY);
       }
      if(currentFlame>5){
     currentFlame =0;
       }
      crash[i-1]=true;
        }
    }
    
    if(crash[i-1]==false){
    image(enemy,enemyX[i],enemyY[i]);
      }  
    }
        if (enemyX[0] - 5*70 >= width) {
          enemyX[0] = -70;
          enemyY[0] = random(20,140);
          
      crash[0]=false;
      crash[1]=false;
      crash[2]=false;
      crash[3]=false;
      crash[4]=false;
      crash[5]=false;
      crash[6]=false;
      crash[7]=false;
      enemyState  = Slope;
      }
       
      break; 
      
        case Slope:
        enemyX[0]+=speed;
         for(int i = 0; i < numEnemyX ; i++){
        
         enemyX[i]+=speed;
         enemyX[i]=enemyX[0]-70*i;
         enemyY[i]=enemyY[0]+60*(i-1);
         
         if(crash[i+1]==false){
         if(fighterX<enemyX[i]+60&&fighterX+50>enemyX[i]&&
            fighterY+50>enemyY[i]&&fighterY<enemyY[i]+60){
    
              flameX=enemyX[i];
              flameY=enemyY[i];
              enemyX[i]=1000;
              enemyY[i]=1000;
              if(frameCount%6==0){
              currentFlame++;
                 }
              if(currentFlame<5){
              image(flame[currentFlame],flameX,flameY);
                 }
              if(currentFlame>5){
              currentFlame =0;
                 }
              crash[i-1]=true;
                 }
               }//explode
              if(crash[i+1]==false){
              image(enemy,enemyX[i],enemyY[i]); 
                 }  
        }
         
         if(enemyX[0] - 6*70 >= width) {
          enemyDiamondX[0]=-80;
          enemyY[0] = random(140,250);
          
           crash[0]=false;
           crash[1]=false;
           crash[2]=false;
           crash[3]=false;
           crash[4]=false;
           crash[5]=false;
           crash[6]=false;
           crash[7]=false;
           enemyState=Diamond;
          }
           break;
       
       case Diamond:
       enemyDiamondX[0]+=speed;
       for(int i=0;i<3;i++){
            image(enemy,enemyX[0]-i*70,enemyY[0]-i*70);
            image(enemy,enemyX[0]-i*70,enemyY[0]+i*70);
            image(enemy,enemyX[0]-(4-i)*70,enemyY[0]-i*70);
            image(enemy,enemyX[0]-(4-i)*70,enemyY[0]+i*70);
           
            if(crash[i+1]==false){
            if(fighterX<enemyDiamondX[i]+61&&fighterX+51>enemyDiamondX[i]&&
               fighterY+51>enemyDiamondY[i]&&fighterY<enemyDiamondY[i]+61){
        
            flameX=enemyDiamondX[i];
            flameY=enemyDiamondY[i];
            
           if(frameCount%6==0){
            currentFlame++;
           }
           if(currentFlame<5){
           image(flame[currentFlame],flameX,flameY);
           
           }
           if(currentFlame>5){
           currentFlame =0;
           }
           crash[i+1]=true;
            }
          }
            if(crash[i+1]==false){
            image(enemy,enemyDiamondX[i],enemyDiamondY[i]);
            }
          }
       
       if(enemyDiamondX[0] - 4*70 >= width) {
        enemyX[0] = -70;
        enemyY[0] = random(80,400);
        
        
        crash[0]=false;
        crash[1]=false;
        crash[2]=false;
        crash[3]=false;
        crash[4]=false;
        crash[5]=false;
        crash[6]=false;
        crash[7]=false;
        enemyState=Straight;
        }  
      }
      break;
      
      case GAME_LOSE:
      image(end2, 0, 0 );
    //mouse action
    if (444 > mouseX && mouseX > 213 && 352 > mouseY && mouseY > 309   ){ 
      image(end1,0,0);
    if (mousePressed){
          // click
          gameState = GAME_RUN;
          hpState = FULL;
          enemyState = Straight;
           //crash initial
          crash[0]=false;
          crash[1]=false;
          crash[2]=false;
          crash[3]=false;
          crash[4]=false;
          crash[5]=false;
          crash[6]=false;
          crash[7]=false;
          
          shootCount=0;
          fighterX = 580;
          fighterY = floor(random(60,420));
          fighterSpeed = 5;
          enemyX[0] = 0;
          treasureX = random(60,580);
          treasureY = random(60,420);
          hpX = 42;
         }
       }
      break;
     }
  }


void keyPressed(){
  if (key == CODED) {  // detect special keys
    switch (keyCode) {  
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}
  

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }
}
