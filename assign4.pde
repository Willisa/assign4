//GAMESTATES
final int GAME_START    = 1;
final int GAME_RUN      = 2;
final int GAME_LOSE     = 3;

//enemy control
final int Straight  = 1;
final int Slope     = 2;
final int Diamond   = 3; 

PImage fighter ;
PImage hp ;
PImage treasure;
PImage bg1;
PImage bg2;
PImage end1;
PImage end2;
PImage enemy1;
PImage start1;
PImage start2;
float treasureX,treasureY;
float fighterX,fighterY;
float hpX=42;
float speed=6;

int bgx1, bgx2;


boolean upPressed=false;
boolean downPressed=false;
boolean leftPressed=false;
boolean rightPressed=false;

int numCrash=8;
boolean crash[]=new boolean [numCrash];

//enemy

int numEnemyX=6;
float enemyX[]=new float[numEnemyX];
int numEnemyY=6;
float enemyY[]=new float[numEnemyY];

int numDiamondEnemyX=9;
float enemyDiamondX[]=new float[numDiamondEnemyX];
int numDiamondEnemyY=9;
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
int gameState;
int enemyState;

void setup () {
  size(640,480);
  //image loading
  bg1=loadImage("img/bg1.png");
  bg1.resize(640,480);
  bg2=loadImage("img/bg2.png");
  bg2.resize(640,480);
  enemy1=loadImage("img/enemy.png");
  fighter=loadImage("img/fighter.png");
  hp=loadImage("img/hp.png");
  treasure=loadImage("img/treasure.png");
  end1=loadImage("img/end1.png");
  end2=loadImage("img/end2.png");
  start1=loadImage("img/start1.png");
  start2=loadImage("img/start2.png");
  shoot=loadImage("img/shoot.png");
  
  fighterX=580;
  fighterY=240;
  
  enemyX[0]=-80;
  enemyY[0]=random(60,420);
  
  image(treasure,treasureX,treasureY);
  treasureX=floor(random(60,580));
  treasureY=floor(random(60,420));
  
  gameState = GAME_START;
  enemyState = Straight;

  //flame
  currentFlame=0;
  for(int j=0; j<numFlame; j++){
   flame[j]=loadImage("img/flame"+(j+1)+".png");
  }
 
  frameRate(100);
  
 
  
}

void draw() {
  switch(gameState){
    case GAME_START:
    image(start2,0,0);
    //mouse action
    if (444 >= mouseX && mouseX >= 213 &&  420 >= mouseY && mouseY >= 381){
     image(start1,0,0);
     if (mousePressed){
       // click
      switch(gameState){
      case GAME_START:
      gameState=GAME_RUN;
      break;
      }
     }
    }
    break;
    
   case GAME_RUN: 
    //scrolling background
    bgx1=bgx1%1280;
    bgx1++;
    image(bg1,bgx1,0);
    image(bg2,bgx1-640,0);
    image(bg1,bgx1-1280,0);
    //treasure
    image(treasure,treasureX,treasureY);
    //fighter 
    image(fighter,fighterX,fighterY);
    // move fighter 
    if(fighterX<0){
    fighterX=0;
    }
    if(fighterX>580){
    fighterX=580;
    }
    if(fighterY<0){
    fighterY=0;
    }
    if(fighterY>420){
    fighterY=420;
    }
    //hp
    fill(255,0,0);
    rect(13,3,hpX,20);
    image(hp,0,0);
   
    //fighter get treasure
    if (sq(treasureX+20.5-fighterX-25.5)+sq(treasureY+20.5-fighterY-25.5)<sq(20.5+25.5)){
    treasureX=floor(random(0,580));
    treasureY=floor(random(0,420));
    hpX+=19.4;
    }
    
    //blood upper bound 
    if (hpX>=194.0){
    hpX=194.0;
    }
  
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

    switch(enemyState){
       
    case Straight:
    
    enemyX[0]+=speed;
    for(int i=1; i<numEnemyX; i++){  
      
    enemyX[i]=enemyX[0]-80*i;
    enemyY[i]=enemyY[0];
    if(crash[i-1]==false){
    if(fighterX<enemyX[i]+61&&fighterX+51>enemyX[i]&&
       fighterY+51>enemyY[i]&&fighterY<enemyY[i]+61){
   
    hpX-=38.8;
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
    image(enemy1,enemyX[i],enemyY[i]);
       }
    }
    
    if(enemyX[0]-80*5 >= width){
    enemyX[0] = -80;
    enemyY[0] = random(20,140);
    
    switch(enemyState){
    case Straight:
    enemyState=Slope;
    crash[0]=false;
    crash[1]=false;
    crash[2]=false;
    crash[3]=false;
    crash[4]=false;
    crash[5]=false;
    crash[6]=false;
    crash[7]=false;
    break;
      }
    }
    break;
    
    case Slope:
    enemyX[0]+=speed;
    for(int i=1; i<numEnemyX; i++){   
    
    enemyX[i]+=speed;
    enemyX[i]=enemyX[0]-80*i;
    
    enemyY[i]=enemyY[0]+61*(i-1);
    
    
    if(crash[i-1]==false){
    if(fighterX<enemyX[i]+61&&fighterX+51>enemyX[i]&&
       fighterY+51>enemyY[i]&&fighterY<enemyY[i]+61){
    
    
    hpX-=38.8;
    
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
   if(crash[i-1]==false){
   image(enemy1,enemyX[i],enemyY[i]); 
   }  
  }
    
    if(enemyX[0]-80*6>=width){
    enemyDiamondX[0]=-80;
    enemyY[0]=random(140,250);
    
    switch(enemyState){
    case Slope:
    enemyState=Diamond;
    crash[0]=false;
    crash[1]=false;
    crash[2]=false;
    crash[3]=false;
    crash[4]=false;
    crash[5]=false;
    crash[6]=false;
    crash[7]=false;
    break;
      }
    }
    break;
    
   case Diamond:
   enemyDiamondX[0]+=speed;
    for(int i=1; i<numDiamondEnemyX; i++){
  
    if(i==1||i==8){
    enemyDiamondX[1]=enemyDiamondX[0];
    enemyDiamondX[8]=enemyDiamondX[0]-61*4;
    enemyDiamondY[i]=enemyY[0];
   
    }else if(i==2||i==6){
    enemyDiamondX[2]=enemyDiamondX[0]-61;
    enemyDiamondX[6]=enemyDiamondX[0]-61*3;
    enemyDiamondY[i]=enemyY[0]-61;
  
    }else if(i==3||i==7){
    enemyDiamondX[3]=enemyDiamondX[0]-61;
    enemyDiamondX[7]=enemyDiamondX[0]-61*3;
    enemyDiamondY[i]=enemyY[0]+61;
   
    }else if(i==4){
    enemyDiamondX[4]=enemyDiamondX[0]-61*2;
    enemyDiamondY[i]=enemyY[0]-122;

    }else{
    enemyDiamondX[i]=enemyDiamondX[0]-61*2;
    enemyDiamondY[i]=enemyY[0]+122;
    }
    
    if(crash[i-1]==false){
    if(fighterX<enemyDiamondX[i]+61&&fighterX+51>enemyDiamondX[i]&&fighterY+51>enemyDiamondY[i]&&fighterY<enemyDiamondY[i]+61){
    
    hpX-=38.8;
    
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
   
   crash[i-1]=true;
       }
    }
    if(crash[i-1]==false){
    image(enemy1,enemyDiamondX[i],enemyDiamondY[i]);
       }
    }
   if(enemyDiamondX[0]-80*4>=width){
    enemyX[0]=-80;
    enemyY[0]=random(0,419);
    
    switch(enemyState){
    case Diamond:
    enemyState=Straight;
    crash[0]=false;
    crash[1]=false;
    crash[2]=false;
    crash[3]=false;
    crash[4]=false;
    crash[5]=false;
    crash[6]=false;
    crash[7]=false;
    break;
       }
    }
    break;
    }
    break; 
    
    case GAME_LOSE:
    image(end2,0,0);
    if (mouseX<431 && mouseX>208 && mouseY>312 && mouseY<345){
     image(end1,0,0);
     if (mousePressed){
     switch(gameState){
     case GAME_LOSE:
     gameState=GAME_RUN;
     enemyState=Straight;
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
     treasureX=floor(random(0,580));
     treasureY=floor(random(0,420));
     fighterX=580;
     fighterY=240;
     hpX=38.8;
     enemyX[0]=-80;
     enemyY[0]=random(0,420);
     break;
      }
     }
    }
    break;   
  }//switch gameState end

   //game over
   if(hpX<=0.0){
   switch(gameState){
   case GAME_RUN:
   gameState=GAME_LOSE;
   break;
     }
   }
   
   //fighter control
   if(upPressed){
   fighterY-=speed;
   }
   if(downPressed){
   fighterY+=speed;
   }
   if(leftPressed){
   fighterX-=speed;
   }
   if(rightPressed){
   fighterX+=speed;
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
