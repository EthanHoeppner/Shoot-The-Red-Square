public float player_x;
public float player_y;
public float player_vx;
public float player_vy;
public int player_health;
public int ammo;
public int ammo_type;

public float camera_x;
public float camera_y;

public float boss_x;
public float boss_y;
public float boss_vx;
public float boss_vy;
public int boss_size;
public int boss_health;
public int boss_health_max;
public int boss_phase;
public int boss_step;

public float w_scale;

public boolean in_up;
public boolean in_down;
public boolean in_left;
public boolean in_right;

public ArrayList<PlayerBullet> PlayerBullets;
public ArrayList<Explosion> Explosions;
public ArrayList<BossBullet> BossBullets;
public ArrayList<Explosion> BossExplosions;
public ArrayList<Filler> Fillers;
public ArrayList<Pickup> Pickups;
public int shot_delay;

public boolean in_ml;

public int tutorial;
public int tutorial_step;

public int[][] grid;

void setup()
{
  size(800, 800);
  grid=new int[100][100];
  w_scale=(float)width/1000.0f;
  PFont font=loadFont("OpenSans-Bold-48.vlw");
  textFont(font);
  textSize(40*w_scale);
  textAlign(CENTER, CENTER);

  player_health=75;
  player_x=500;
  player_y=900;
  ammo=0;
  ammo_type=0;
  shot_delay=0;
  tutorial=0;

  boss_health_max=5;
  boss_health=5;
  boss_phase=-1;
  boss_step=0;

  camera_x=player_x;
  camera_y=player_y;

  boss_size=100;
  boss_x=500;
  boss_y=500;
  boss_vx=0;
  boss_vy=0;

  player_vx=0;
  player_vy=0;
  in_up=false;
  in_down=false;
  in_right=false;
  in_left=false;
  PlayerBullets=new ArrayList<PlayerBullet>();
  Explosions=new ArrayList<Explosion>();
  BossBullets=new ArrayList<BossBullet>();
  BossExplosions=new ArrayList<Explosion>();
  Fillers=new ArrayList<Filler>();
  Pickups=new ArrayList<Pickup>();
  frameRate(60);

  for (int i=0; i<100; i++)
  {
    grid[i][0]=1;
    grid[i][99]=1;
    grid[0][i]=1;
    grid[99][i]=1;
  }
  
  for(int i=30;i<70;i++)
  {
    grid[i][20]=1;
    grid[i][21]=1;
    grid[i][22]=1;
    
    grid[i][78]=1;
    grid[i][79]=1;
    grid[i][80]=1;
    
    grid[20][i]=1;
    grid[21][i]=1;
    grid[22][i]=1;
    
    grid[78][i]=1;
    grid[79][i]=1;
    grid[80][i]=1;
  }
}

void draw()
{
  for (int i=0; i<100; i++)
  {
    grid[i][0]=1;
    grid[i][99]=1;
    grid[0][i]=1;
    grid[99][i]=1;
  }
  
  if(random(250)<=1 && tutorial==-1)
  {
    Pickups.add(new Pickup(random(1000),random(1000),(int)random(4)));
  }
  
  player_move();
  player_shoot();
  bullets_move();

  boss_move();
  boss_bullets_move();
  fillers_move();
  pickups_update();

  camera_x=0.8f*camera_x+0.2f*((player_x+boss_x-1000)/2.0f);
  camera_y=0.8f*camera_y+0.2f*((player_y+boss_y-1000)/2.0f);

  fill(255, 100);
  noStroke();
  rect(0, 0, width, height);

  fill(0);

  fill(0, 255, 0);
  stroke(0);
  strokeWeight(2*w_scale);
  rect((player_x-7.0)*w_scale-camera_x*w_scale, (player_y-7.0)*w_scale-camera_y*w_scale, 14.0*w_scale, 14*w_scale);

  stroke(100);
  strokeWeight(2*w_scale);
  fill(150);
  for (int i=0; i<100; i++)
  {
    for (int i2=0; i2<100; i2++)
    {
      if (grid[i][i2]==1)
      {
        rect(w_scale*10*i-camera_x*w_scale, w_scale*10*i2-camera_y*w_scale, 10*w_scale, 10*w_scale);
      }
    }
  }
  boss_draw();
  bullets_draw();
  boss_bullets_draw();
  explosions_draw();
  fillers_draw();
  pickups_draw();

  noStroke();
  fill(100);
  rect(w_scale*(-1000-camera_x), w_scale*(-1000-camera_y), 1000*w_scale, 3000*w_scale);
  rect(w_scale*(1000-camera_x), w_scale*(-1000-camera_y), 1000*w_scale, 3000*w_scale);
  rect(w_scale*(-1000-camera_x), w_scale*(-1000-camera_y), 3000*w_scale, 1000*w_scale);
  rect(w_scale*(-1000-camera_x), w_scale*(1000-camera_y), 3000*w_scale, 1000*w_scale);

  fill(0);
  rect(740*w_scale, 40*w_scale, 220*w_scale, 60*w_scale);
  fill(255);
  rect(750*w_scale, 50*w_scale, 200*w_scale, 40*w_scale);
  fill(255, 0, 0);
  rect(750*w_scale, 50*w_scale, player_health*2*w_scale, 40*w_scale);
  fill(0);
  text(player_health, 850*w_scale, 70*w_scale);

  if (ammo>0)
  {
    fill(0);
    rect(890*w_scale, 130*w_scale, 70*w_scale, 70*w_scale);
    fill(255);
    rect(900*w_scale, 140*w_scale, 50*w_scale, 50*w_scale);
    fill(0);
    text(ammo, 925*w_scale, 165*w_scale);
  }

  if(player_health>100)
  {
    player_health=100;
  }
  if(player_health<=0)
  {
    fill(255);
    stroke(0);
    strokeWeight(5*w_scale);
    rect(250*w_scale,425*w_scale,500*w_scale,150*w_scale);
    fill(0);
    text("You Lost.\nHit Space to try again.",500*w_scale,500*w_scale);
    noLoop();
  }
  fill(0);
  rect(50*w_scale, 915*w_scale, 900*w_scale, 50*w_scale);
  fill(255, 0, 0);
  rect(60*w_scale, 925*w_scale, 880*w_scale*(boss_health/(float)boss_health_max), 30*w_scale);
  tutorial_update();
}

void keyPressed()
{
  switch (Character.toLowerCase(key))
  {
  case 'w':
    in_up=true;
    break;
  case 's':
    in_down=true;
    break;
  case 'a':
    in_left=true;
    break;
  case 'd':
    in_right=true;
    break;
  case ' ':
    setup();
    loop();
    break;
  }
}

void keyReleased()
{
  switch (key)
  {
  case 'w':
    in_up=false;
    break;
  case 's':
    in_down=false;
    break;
  case 'a':
    in_left=false;
    break;
  case 'd':
    in_right=false;
    break;
  }
}

void mousePressed()
{
  if (mouseButton==LEFT)
  {
    in_ml=true;
  }
}

void mouseReleased()
{
  if (mouseButton==LEFT)
  {
    in_ml=false;
  }
}

void player_move()
{
  if(terrain_collide(player_x-7,player_y-7,player_x+7,player_y+7))
  {
    grid[(int)(player_x-7)/10][(int)(player_y-7)/10]=0;
    grid[(int)(player_x+7)/10][(int)(player_y-7)/10]=0;
    grid[(int)(player_x-7)/10][(int)(player_y+7)/10]=0;
    grid[(int)(player_x+7)/10][(int)(player_y+7)/10]=0;
  }
  float dx=0;
  float dy=0;
  if (in_right)
  {
    dx++;
  }
  if (in_left)
  {
    dx--;
  }
  if (in_down)
  {
    dy++;
  }
  if (in_up)
  {
    dy--;
  }

  if (abs(dx)+abs(dy)>1.9f)
  {
    dx*=sqrt(2)/2.0f;
    dy*=sqrt(2)/2.0f;
  }

  dx*=1.5;
  dy*=1.5;

  player_vx+=dx;
  player_vy+=dy;

  player_vx*=0.86f;
  player_vy*=0.86f;

  if (terrain_collide(player_x-7+player_vx, player_y-7+player_vy, player_x+7+player_vx, player_y+7+player_vy))
  {
    if (!terrain_collide(player_x-7, player_y-7+player_vy, player_x+7, player_y+7+player_vy))
    {
      player_vx=0;
    } else
    {
      if (!terrain_collide(player_x-7+player_vx, player_y-7, player_x+7+player_vx, player_y+7))
      {
        player_vy=0;
      } else
      {
        player_vx=0;
        player_vy=0;
      }
    }
  }

  player_x+=player_vx;
  player_y+=player_vy;
}

void player_shoot()
{
  shot_delay--;
  if (in_ml && shot_delay<0)
  {
    float accuracy=1;
    float speed=1;

    switch(ammo_type)
    {
    case 0:
      accuracy=16;
      speed=12;
      shot_delay=15;
      break;
    case 1:
      accuracy=64;
      speed=18;
      shot_delay=40;
      break;
    case 2:
      accuracy=5;
      speed=8;
      shot_delay=1;
      break;
    case 3:
      accuracy=128;
      speed=14;
      shot_delay=1;
      break;
    }

    float dx=mouseX-(player_x-camera_x)*w_scale;
    float dy=mouseY-(player_y-camera_y)*w_scale;

    float total=abs(dx)+abs(dy);

    dx/=total;
    dy/=total;

    float newAngle=atan(dy/dx)+random(PI/accuracy)-PI/(accuracy*2);

    if (dx/abs(dx)>=0)
    {
      dx=cos(newAngle);
      dy=sin(newAngle);
    } else
    {
      dx=-cos(newAngle);
      dy=-sin(newAngle);
    }


    PlayerBullets.add(new PlayerBullet(player_x, player_y, speed*dx, speed*dy, ammo_type));
    ammo--;
    if (ammo<=0)
    {
      ammo=0;
      ammo_type=0;
    }
  }
}

void bullets_move()
{
  for (int i=0; i<PlayerBullets.size(); i++)
  {
    PlayerBullet bullet=PlayerBullets.get(i);
    bullet.x+=bullet.vx/2;
    bullet.y+=bullet.vy/2;
    if (abs(bullet.vx)>10 || abs(bullet.vy)>10)
    {
      if (point_collide(bullet.x, bullet.y))
      {
        destroy_bullet(i);
        i--;
        continue;
      }
    }
    bullet.x+=bullet.vx/2;
    bullet.y+=bullet.vy/2;
    if (point_collide(bullet.x, bullet.y))
      {
        destroy_bullet(i);
        i--;
        continue;
      }
    if (bullet.x>=boss_x-boss_size/2 && bullet.x<=boss_x+boss_size/2 && bullet.y>=boss_y-boss_size/2 && bullet.y<=boss_y+boss_size/2)
    {
      destroy_bullet(i);
      i--;
    }
  }
}

void bullets_draw()
{
  strokeWeight(2*w_scale);
  stroke(0);
  for (int i=0; i<PlayerBullets.size(); i++)
  {
    PlayerBullet bullet=PlayerBullets.get(i);
    switch(bullet.type)
    {
    case 0:
      fill(200);
      ellipse(bullet.x*w_scale-camera_x*w_scale, bullet.y*w_scale-camera_y*w_scale, 8.0*w_scale, 8.0*w_scale);
      break;
    case 1:
      fill(255, 0, 0);
      ellipse(bullet.x*w_scale-camera_x*w_scale, bullet.y*w_scale-camera_y*w_scale, 20.0*w_scale, 20.0*w_scale);
      break;
    case 2:
      fill(255, 100, 0);
      ellipse(bullet.x*w_scale-camera_x*w_scale, bullet.y*w_scale-camera_y*w_scale, 14.0*w_scale, 14.0*w_scale);
      break;
    case 3:
      fill(100, 255, 100);
      ellipse(bullet.x*w_scale-camera_x*w_scale, bullet.y*w_scale-camera_y*w_scale, 12.0*w_scale, 12.0*w_scale);
      break;
    }
  }
}

void destroy_bullet(int index)
{
  PlayerBullet bullet=PlayerBullets.get(index);
  switch(bullet.type)
  {
  case 0:
    Explosions.add(new Explosion(bullet.x, bullet.y, 100, 100, 100, 20, 10, true));
    explode(bullet.x, bullet.y, 20);
    break;
  case 1:
    Explosions.add(new Explosion(bullet.x, bullet.y, 255, 200, 0, 150, 60, true));
    explode(bullet.x, bullet.y, 150);
    break;
  case 2:
    Explosions.add(new Explosion(bullet.x, bullet.y, 255, 100, 0, 40, 10, true));
    explode(bullet.x, bullet.y, 60);
    break;
  case 3:
    Explosions.add(new Explosion(bullet.x, bullet.y, 255, 100, 0, 30, 8, true));
    explode(bullet.x, bullet.y, 30);
    break;
  }
  PlayerBullets.remove(index);
}

void explosions_draw()
{
  strokeWeight(3*w_scale);
  stroke(0);
  for (int i=0; i<Explosions.size(); i++)
  {
    Explosion explosion=Explosions.get(i);

    if (!explosion.friendly)
    {
      if (sqrt((explosion.x-player_x)*(explosion.x-player_x)+(explosion.y-player_y)*(explosion.y-player_y))<explosion.size*0.5f+7)
      {
        player_health-=explosion.damage;
        knockback(explosion.x, explosion.y, explosion.damage*2);
        explosion.friendly=true;
      }
    }

    fill(explosion.r, explosion.g, explosion.b);
    float draw_size=explosion.size*0.5f*(1+(float)explosion.age/10.0f);
    ellipse(explosion.x*w_scale-camera_x*w_scale, explosion.y*w_scale-camera_y*w_scale, draw_size*w_scale, draw_size*w_scale);
    explosion.age++;
    if (explosion.age>10)
    {
      Explosions.remove(i);
      i--;
    }
  }
}

void boss_move()
{ 
  for (int i=0; i<Explosions.size(); i++)
  {
    Explosion explosion=Explosions.get(i);
    if (!BossExplosions.contains(explosion))
    {
      if (sqrt((explosion.x-boss_x)*(explosion.x-boss_x)+(explosion.y-boss_y)*(explosion.y-boss_y))<explosion.size*0.5f*(1+(float)explosion.age/10.0f)+boss_size/2)
      {
        boss_health-=explosion.damage;
        BossExplosions.add(explosion);
      }
    }
  }

  switch (boss_phase)
  {
  case -1:
    if(boss_health<0)
    {
      boss_phase=0;
      boss_health_max=350;
      boss_health=350;
    }
    break;
  case 0:
    boss_step++;
    if(boss_step>0)
    {
      if (boss_vx==0)
      {
        boss_vx=1;
        if (random(100)>50)
        {
          boss_vx=-1;
        }
      }
      if (boss_vy==0)
      {
        boss_vy=1;
        if (random(100)>50)
        {
          boss_vy=-1;
        }
      }
  
      if (terrain_collide(boss_x-boss_size/2+boss_vx, boss_y-boss_size/2+boss_vy, boss_x+boss_size/2+boss_vx, boss_y+boss_size/2+boss_vy))
      {
        if (!terrain_collide(boss_x-boss_size/2+boss_vx, boss_y-boss_size/2, boss_x+boss_size/2+boss_vx, boss_y+boss_size/2))
        {
          boss_vx*=-1;
        } 
        else
        {
          if (!terrain_collide(boss_x-boss_size/2, boss_y-boss_size/2+boss_vy, boss_x+boss_size/2, boss_y+boss_size/2+boss_vy))
          {
            boss_vy*=-1;
          } 
          else
          {
            boss_vx*=-1;
            boss_vy*=-1;
          }
        }
      }
      
      if (abs(boss_x-player_x)<boss_size/2+7 && abs(boss_y-player_y)<boss_size/2+7)
      {
        player_health-=15;
        knockback(boss_x, boss_y, 30);
      }
      
      if(boss_step>100 && boss_step%60==0)
      {
        float theta=atan((boss_y-player_y)/(boss_x-player_x));
        float vx=6*cos(theta);
        float vy=6*sin(theta);
        if(boss_x-player_x>0)
        {
          vx*=-1;
          vy*=-1;
        }
        
        if(boss_step>100 && boss_step%40==0)
        {
          float dx=0;
          float dy=0;
          while(sqrt((dx)*(dx)+(dy)*(dy))<400)
          {
            dx=random(700)-350;
            dy=random(700)-350;
          }
          Fillers.add(new Filler(boss_x,boss_y,boss_x+dx,boss_y+dy,12,3));
        }
        BossBullets.add(new BossBullet(boss_x, boss_y, vx,vy, 40, 10));
      }
    }
    if(boss_health<=0)
    {
      if(boss_step%6==0)
      {
        boss_size-=2;
        Explosions.add(new Explosion(boss_x+random(boss_size)-boss_size/2, boss_y+random(boss_size)-boss_size/2, 255,200,0, 3*boss_size/4+random(50), 5, false));
      }
      if(boss_step>0)
      {
        boss_step=-61;
        boss_vx=0;
        boss_vy=0;
      }
      if(boss_step==0)
      {
        boss_phase=1;
        boss_health_max=700;
        boss_health=700;
        boss_size=90;
      }
    }
    break;
  case 1:
    boss_step++;
    if(boss_step>0)
    {
      if (boss_vx==0)
      {
        boss_vx=2;
        if (random(100)>50)
        {
          boss_vx=-2;
        }
      }
      if (boss_vy==0)
      {
        boss_vy=2;
        if (random(100)>50)
        {
          boss_vy=-2;
        }
      }
  
      if (terrain_collide(boss_x-boss_size/2+boss_vx, boss_y-boss_size/2+boss_vy, boss_x+boss_size/2+boss_vx, boss_y+boss_size/2+boss_vy))
      {
        if (!terrain_collide(boss_x-boss_size/2+boss_vx, boss_y-boss_size/2, boss_x+boss_size/2+boss_vx, boss_y+boss_size/2))
        {
          boss_vx*=-1;
        } 
        else
        {
          if (!terrain_collide(boss_x-boss_size/2, boss_y-boss_size/2+boss_vy, boss_x+boss_size/2, boss_y+boss_size/2+boss_vy))
          {
            boss_vy*=-1;
          } 
          else
          {
            boss_vx*=-1;
            boss_vy*=-1;
          }
        }
      }
  
      if (abs(boss_x-player_x)<boss_size/2+7 && abs(boss_y-player_y)<boss_size/2+7)
      {
        player_health-=15;
        knockback(boss_x, boss_y, 30);
      }
      
      if((boss_step/40)%2==0)
      {
        if(boss_step%5==0)
        {
          float theta=0+((boss_step%40)/5)*PI/16;
          BossBullets.add(new BossBullet(boss_x, boss_y, cos(theta)*5,sin(theta)*5, 40, 10));
          theta=PI/2+((boss_step%40)/5)*PI/16;
          BossBullets.add(new BossBullet(boss_x, boss_y, cos(theta)*5,sin(theta)*5, 40, 10));
          theta=PI+((boss_step%40)/5)*PI/16;
          BossBullets.add(new BossBullet(boss_x, boss_y, cos(theta)*5,sin(theta)*5, 40, 10));
          theta=3*PI/2+((boss_step%40)/5)*PI/16;
          BossBullets.add(new BossBullet(boss_x, boss_y, cos(theta)*5,sin(theta)*5, 40, 10));
        }
      }
      if(boss_step%75==0)
      {
        for(int i=0;i<3;i++)
        {
          float dx=0;
          float dy=0;
          while(sqrt((dx)*(dx)+(dy)*(dy))<400)
          {
            dx=random(700)-350;
            dy=random(700)-350;
          }
          Fillers.add(new Filler(boss_x,boss_y,boss_x+dx,boss_y+dy,12,3));
        }
      }
    }
    if(boss_health<=0)
    {
      if(boss_step%6==0)
      {
        boss_size-=2;
        Explosions.add(new Explosion(boss_x+random(boss_size)-boss_size/2, boss_y+random(boss_size)-boss_size/2, 255,200,0, 3*boss_size/4+random(50), 5, false));
      }
      if(boss_step>0)
      {
        boss_step=-61;
        boss_vx=0;
        boss_vy=0;
      }
      if(boss_step==0)
      {
        boss_phase=2;
        boss_health_max=500;
        boss_health=500;
        boss_size=80;
      }
    }
    break;
    case 2:
      boss_step++;
      if(boss_step>0)
      {
        if (abs(boss_x-player_x)<boss_size/2+7 && abs(boss_y-player_y)<boss_size/2+7)
        {
          player_health-=15;
          knockback(boss_x, boss_y, 30);
        }
        if(boss_step%720==0 || boss_step==1)
        {
          for(int i=-120;i<=120;i+=80)
          {
            Fillers.add(new Filler(boss_x,boss_y,boss_x+180,boss_y+i,5,2));
            Fillers.add(new Filler(boss_x,boss_y,boss_x-180,boss_y+i,5,2));
            Fillers.add(new Filler(boss_x,boss_y,boss_x+i,boss_y+180,5,2));
            Fillers.add(new Filler(boss_x,boss_y,boss_x+i,boss_y-180,5,2));
          }
        }
        if((boss_step/30)%24>0 && (boss_step/30)%24<13)
        {
          boss_vx=0;
          boss_vy=0;
          if(boss_step%45==0 || (boss_step-7)%45==0 || (boss_step-14)%45==0 || (boss_step-21)%45==0)
          {
            float theta=atan((boss_y-player_y)/(boss_x-player_x));
            float dx=cos(theta);
            float dy=sin(theta);
            
            if(player_x-boss_x<0)
            {
              dx*=-1;
              dy*=-1;
            }
            
            BossBullet bullet=new BossBullet(boss_x, boss_y, 12*dx,12*dy, 50, 6);
            bullet.explosion_size=90;
            bullet.explosion_g=200;
            BossBullets.add(bullet);
          }
        }
        if((boss_step/30)%24>=13)
        {
          if(boss_step%720==390 || boss_step%720==450 || boss_step%720==530)
          {
            float theta=atan((boss_y-player_y)/(boss_x-player_x));
            float dx=cos(theta);
            float dy=sin(theta);
            
            if(player_x-boss_x<0)
            {
              dx*=-1;
              dy*=-1;
            }
            
            boss_vx=dx*13;
            boss_vy=dy*13;
          }
          if(boss_step%720==440 || boss_step%720==500 || boss_step%720==580)
          {
            boss_vx=0;
            boss_vy=0;
            for(float i=0;i<=16;i++)
            {
              float theta=PI*i/8;
              BossBullet bullet=new BossBullet(boss_x, boss_y, 2*cos(theta),2*sin(theta), 50, 6);
              bullet.explosion_size=90;
              bullet.explosion_g=200;
              BossBullets.add(bullet);
              bullet=new BossBullet(boss_x, boss_y, cos(theta-PI/32),sin(theta-PI/32), 50, 6);
              bullet.explosion_size=90;
              bullet.explosion_g=200;
              BossBullets.add(bullet);
            }
          }
          if(terrain_collide(boss_x-boss_size/2, boss_y-boss_size/2, boss_x+boss_size/2, boss_y+boss_size/2))
          {
            if(boss_x-boss_size/2<20 || boss_x+boss_size/2>990 || boss_y-boss_size/2<20 || boss_y+boss_size/2>980)
            {
              if(boss_x-boss_size/2<10)
              {
                boss_vx*=-1;
              }
              if(boss_x+boss_size/2>990)
              {
                boss_vx*=-1;
              }
              if(boss_y-boss_size/2<10)
              {
                boss_vy*=-1;
              }
              if(boss_y+boss_size/2>990)
              {
                boss_vy*=-1;
              }
              boss_x+=boss_vx;
              boss_y+=boss_vy;
            }
            else
            {
              for(int i=(int)boss_x-boss_size/2;i<=boss_x+boss_size/2;i+=10)
              {
                for(int i2=(int)boss_y-boss_size/2;i2<=boss_y+boss_size/2;i2+=10)
                {
                  grid[i/10][i2/10]=0;
                }
              }
            }
          }
        }
      }
      if(boss_health<=0)
      {
        if(boss_step%6==0)
        {
          boss_size-=2;
          Explosions.add(new Explosion(boss_x+random(boss_size)-boss_size/2, boss_y+random(boss_size)-boss_size/2, 255,200,0, 3*boss_size/4+random(50), 5, false));
        }
        if(boss_step>0)
        {
          boss_step=-61;
          boss_vx=0;
          boss_vy=0;
        }
        if(boss_step==0)
        {
          boss_phase=3;
          boss_health_max=700;
          boss_health=700;
          boss_size=70;
        }
      }
      break;
    case 3:
      boss_step++;
      if(boss_step>0)
      {
        if (abs(boss_x-player_x)<boss_size/2+7 && abs(boss_y-player_y)<boss_size/2+7)
        {
          player_health-=15;
          knockback(boss_x, boss_y, 30);
        }
        
        if (boss_vx==0)
        {
          boss_vx=2;
          if (random(100)>50)
          {
            boss_vx=-1;
          }
        }
        if (boss_vy==0)
        {
          boss_vy=2;
          if (random(100)>50)
          {
            boss_vy=-1;
          }
        }
        
        boss_vx=(boss_vx/abs(boss_vx))*(2+sin((float)boss_step*PI/30.0f));
        boss_vy=(boss_vy/abs(boss_vy))*(2+sin((float)boss_step*PI/30.0f));
        
        if (terrain_collide(boss_x-boss_size/2+boss_vx, boss_y-boss_size/2+boss_vy, boss_x+boss_size/2+boss_vx, boss_y+boss_size/2+boss_vy))
        {
          if (!terrain_collide(boss_x-boss_size/2+boss_vx, boss_y-boss_size/2, boss_x+boss_size/2+boss_vx, boss_y+boss_size/2))
          {
            boss_vx*=-1;
          } 
          else
          {
            if (!terrain_collide(boss_x-boss_size/2, boss_y-boss_size/2+boss_vy, boss_x+boss_size/2, boss_y+boss_size/2+boss_vy))
            {
              boss_vy*=-1;
            } 
            else
            {
              boss_vx*=-1;
              boss_vy*=-1;
            }
          }
        }
        
        if(boss_step%5==0)
        {
          for(int i=0;i<4;i++)
          {
            float theta=boss_step*PI/180+(float)i*PI/2;
            BossBullet bullet=new BossBullet(boss_x, boss_y, 5*cos(theta),5*sin(theta), 14, 5);
            bullet.explosion_size=16;
            BossBullets.add(bullet);
          }
        }
        
        if(boss_step%90==0)
        {
          float theta=atan((boss_y-player_y)/(boss_x-player_x));
          
          for(int i=0;i<4;i++)
          {
            float dx=cos(theta+(float)i*PI/18-PI/12);
            float dy=sin(theta+(float)i*PI/18-PI/12);
            
            if(player_x-boss_x<0)
            {
              dx*=-1;
              dy*=-1;
            }
            
            BossBullet bullet=new BossBullet(boss_x, boss_y, 8*dx,8*dy, 30, 10);
            BossBullets.add(bullet);
          }
        }
        
        if(boss_step%60==0)
        {
          Fillers.add(new Filler(boss_x,boss_y,random(1000),random(1000),12,3));
        }
      }
      if(boss_health<=0)
      {
        if(boss_step%6==0)
        {
          boss_size-=2;
          Explosions.add(new Explosion(boss_x+random(boss_size)-boss_size/2, boss_y+random(boss_size)-boss_size/2, 255,200,0, 3*boss_size/4+random(50), 5, false));
        }
        if(boss_step>0)
        {
          boss_step=-61;
          boss_vx=0;
          boss_vy=0;
        }
        if(boss_step==0)
        {
          boss_phase=4;
          boss_health_max=600;
          boss_health=600;
          boss_size=60;
        }
      }
      break;
    case 4:
      boss_step++;
      if(boss_step>0)
      {
        if (abs(boss_x-player_x)<boss_size/2+7 && abs(boss_y-player_y)<boss_size/2+7)
        {
          player_health-=15;
          knockback(boss_x, boss_y, 30);
        }
        
        float theta=atan((boss_y-player_y)/(boss_x-player_x));
        
        float dx=cos(theta);
        float dy=sin(theta);
        
        if(player_x-boss_x<0)
        {
          dx*=-1;
          dy*=-1;
        }
        
        boss_vx=0.99f*boss_vx+0.01f*dx*5;
        boss_vy=0.99f*boss_vy+0.01f*dy*5;
        
        if (terrain_collide(boss_x-boss_size/2+boss_vx, boss_y-boss_size/2+boss_vy, boss_x+boss_size/2+boss_vx, boss_y+boss_size/2+boss_vy))
        {
          if (!terrain_collide(boss_x-boss_size/2+boss_vx, boss_y-boss_size/2, boss_x+boss_size/2+boss_vx, boss_y+boss_size/2))
          {
            boss_vx*=-1;
          } 
          else
          {
            if (!terrain_collide(boss_x-boss_size/2, boss_y-boss_size/2+boss_vy, boss_x+boss_size/2, boss_y+boss_size/2+boss_vy))
            {
              boss_vy*=-1;
            } 
            else
            {
              boss_vx*=-1;
              boss_vy*=-1;
            }
          }
        }
        
        if((boss_step/180)%3==0)
        {
          boss_vx=0;
          boss_vy=0;
          if(boss_step%10==0)
          {
            Fillers.add(new Filler(boss_x,boss_y,player_x,player_y,18,3));
          }
        }
        else
        {
          if(boss_step%60==0)
          {
            for(int i=0;i<10;i++)
            {
              theta=PI/4.0f+random(0.3f)-0.15f;
              float power=random(6)+6.0f;
              BossBullet bullet=new BossBullet(boss_x, boss_y, power*cos(theta),power*sin(theta), 30, 2);
              bullet.explosion_size=90;
              bullet.drag=0.95;
              bullet.ax=dx*0.5f;
              bullet.ay=dy*0.5f;
              BossBullets.add(bullet);
              
              theta=3.0f*PI/4.0f+random(0.3f)-0.15f;
              power=random(6)+6.0f;
              bullet=new BossBullet(boss_x, boss_y, power*cos(theta),power*sin(theta), 30, 2);
              bullet.explosion_size=90;
              bullet.drag=0.95;
              bullet.ax=dx*0.5f;
              bullet.ay=dy*0.5f;
              BossBullets.add(bullet);
              
              theta=5.0f*PI/4.0f+random(0.3f)-0.15f;
              power=random(6)+6.0f;
              bullet=new BossBullet(boss_x, boss_y, power*cos(theta),power*sin(theta), 30, 2);
              bullet.explosion_size=90;
              bullet.drag=0.95;
              bullet.ax=dx*0.5f;
              bullet.ay=dy*0.5f;
              BossBullets.add(bullet);
              
              theta=7.0f*PI/4.0f+random(0.3f)-0.15f;
              power=random(6)+6.0f;
              bullet=new BossBullet(boss_x, boss_y, power*cos(theta),power*sin(theta), 30, 2);
              bullet.explosion_size=90;
              bullet.drag=0.95;
              bullet.ax=dx*0.5f;
              bullet.ay=dy*0.5f;
              BossBullets.add(bullet);
            }
          }
        }
      }
      if(boss_health<=0)
      {
        if(boss_step%6==0)
        {
          boss_size-=2;
          Explosions.add(new Explosion(boss_x+random(boss_size)-boss_size/2, boss_y+random(boss_size)-boss_size/2, 255,200,0, 3*boss_size/4+random(50), 5, false));
        }
        if(boss_step>0)
        {
          boss_step=-61;
          boss_vx=0;
          boss_vy=0;
        }
        if(boss_step==0)
        {
          boss_phase=5;
          boss_health_max=700;
          boss_health=700;
          boss_size=50;
        }
      }
      break;
    case 5:
      boss_step++;
      if(boss_step>0)
      {
        if (boss_vx==0)
        {
          boss_vx=2;
          if (random(100)>50)
          {
            boss_vx=-2;
          }
        }
        if (boss_vy==0)
        {
          boss_vy=2;
          if (random(100)>50)
          {
            boss_vy=-2;
          }
        }
    
        if (terrain_collide(boss_x-boss_size/2+boss_vx, boss_y-boss_size/2+boss_vy, boss_x+boss_size/2+boss_vx, boss_y+boss_size/2+boss_vy))
        {
          if (!terrain_collide(boss_x-boss_size/2+boss_vx, boss_y-boss_size/2, boss_x+boss_size/2+boss_vx, boss_y+boss_size/2))
          {
            boss_vx*=-1;
          } 
          else
          {
            if (!terrain_collide(boss_x-boss_size/2, boss_y-boss_size/2+boss_vy, boss_x+boss_size/2, boss_y+boss_size/2+boss_vy))
            {
              boss_vy*=-1;
            } 
            else
            {
              boss_vx*=-1;
              boss_vy*=-1;
            }
          }
        }
    
        if (abs(boss_x-player_x)<boss_size/2+7 && abs(boss_y-player_y)<boss_size/2+7)
        {
          player_health-=15;
          knockback(boss_x, boss_y, 30);
        }
        
        if(boss_step%5==0)
        {
          float theta=atan((boss_y-player_y)/(boss_x-player_x));
          
          float dx=cos(theta-PI/4.0f);
          float dy=sin(theta-PI/4.0f);
          if(player_x-boss_x<0)
          {
            dx*=-1;
            dy*=-1;
          }
          BossBullets.add(new BossBullet(boss_x, boss_y, dx*4, dy*4, 12, 5));
          
          dx=cos(theta);
          dy=sin(theta);
          if(player_x-boss_x<0)
          {
            dx*=-1;
            dy*=-1;
          }
          BossBullets.add(new BossBullet(boss_x, boss_y, dx*4, dy*4, 12, 5));
          
          dx=cos(theta+PI/4.0f);
          dy=sin(theta+PI/4.0f);
          if(player_x-boss_x<0)
          {
            dx*=-1;
            dy*=-1;
          }
          BossBullets.add(new BossBullet(boss_x, boss_y, dx*4, dy*4, 12, 5));
        }
        
        if(boss_step%120==0)
        {
          for(float i=0;i<=16;i++)
            {
              float theta=PI*i/8;
              BossBullet bullet=new BossBullet(boss_x, boss_y, 1.5f*cos(theta),1.5f*sin(theta), 50, 3);
              bullet.explosion_size=90;
              bullet.explosion_g=200;
              BossBullets.add(bullet);
              bullet=new BossBullet(boss_x, boss_y, 0.75f*cos(theta-PI/32),0.75f*sin(theta-PI/32), 50, 3);
              bullet.explosion_size=90;
              bullet.explosion_g=200;
              BossBullets.add(bullet);
            }
        }
        
        if(boss_step%40==0)
        {
          Fillers.add(new Filler(boss_x,boss_y,player_x+random(500)-250,player_y+random(500)-250,6,3));
        }
      }
      if(boss_health<=0)
      {
        if(boss_step%6==0)
        {
          boss_size-=2;
          Explosions.add(new Explosion(boss_x+random(boss_size)-boss_size/2, boss_y+random(boss_size)-boss_size/2, 255,200,0, 3*boss_size/4+random(50), 5, false));
        }
        if(boss_step>0)
        {
          boss_step=-61;
          boss_vx=0;
          boss_vy=0;
        }
        if(boss_step==0)
        {
          Explosions.add(new Explosion(boss_x,boss_y,255,0,0,300,0,true));
          boss_phase=6;
          boss_health_max=1;
          boss_health=1;
          boss_size=0;
          boss_step=0;
        }
      }
      break;
    case 6:
      boss_step++;
      boss_x=player_x;
      boss_y=player_y;
      fill(0);
      text("Victory!!",(boss_x-camera_x)*w_scale,(boss_y-camera_y-50)*w_scale);
      if(boss_step%60==0)
      {
        float x=random(800)+100;
        float y=random(800)+100;
        int bullet_color=(int)random(4);
        for(int i=0;i<30;i++)
        {
          float theta=random(2.0f*PI);
          BossBullet bullet=new BossBullet(x,y, (4+random(2))*cos(theta), (4+random(2))*sin(theta), 60+random(20), 0);
          bullet.drag=0.98;
          bullet.ay=0.05;
          switch(bullet_color)
          {
            case 0:
              bullet.r=255;
              bullet.g=255;
              bullet.b=255;
              bullet.explosion_r=255;
              bullet.explosion_g=255;
              bullet.explosion_b=255;
              break;
            case 1:
              bullet.r=255;
              bullet.g=100;
              bullet.b=100;
              bullet.explosion_r=255;
              bullet.explosion_g=100;
              bullet.explosion_b=100;
              break;
            case 2:
              bullet.r=100;
              bullet.g=255;
              bullet.b=100;
              bullet.explosion_r=100;
              bullet.explosion_g=255;
              bullet.explosion_b=100;
              break;
            case 3:
              bullet.r=100;
              bullet.g=100;
              bullet.b=255;
              bullet.explosion_r=100;
              bullet.explosion_g=100;
              bullet.explosion_b=255;
              break;
          }
          BossBullets.add(bullet);
        }
      }
      break;
  }

  boss_x+=boss_vx;
  boss_y+=boss_vy;
}

void boss_draw()
{
  strokeWeight(4*w_scale);
  stroke(0);
  fill(255, 0, 0);
  rect(w_scale*(boss_x-boss_size/2-camera_x), w_scale*(boss_y-boss_size/2-camera_y), w_scale*boss_size, w_scale*boss_size);
}

void boss_bullets_move()
{
  for (int i=0; i<BossBullets.size(); i++)
  {
    BossBullet bullet=BossBullets.get(i);
    bullet.x+=bullet.vx;
    bullet.y+=bullet.vy;
    bullet.vx+=bullet.ax;
    bullet.vy+=bullet.ay;
    bullet.vx*=bullet.drag;
    bullet.vy*=bullet.drag;
    if (point_collide(bullet.x, bullet.y) || sqrt((bullet.x-player_x)*(bullet.x-player_x)+(bullet.y-player_y)*(bullet.y-player_y))<bullet.size*0.5)
    {
      Explosion explosion=new Explosion(bullet.x, bullet.y, bullet.explosion_r, bullet.explosion_g, bullet.explosion_b, bullet.explosion_size, bullet.damage, false);
      Explosions.add(explosion);
      BossExplosions.add(explosion);
      explode(bullet.x, bullet.y, bullet.size);
      BossBullets.remove(i);
      i--;
    }
  }
}

void boss_bullets_draw()
{
  strokeWeight(2*w_scale);
  stroke(0);
  for (int i=0; i<BossBullets.size(); i++)
  {
    BossBullet bullet=BossBullets.get(i);
    fill(bullet.r, bullet.g, bullet.b);
    ellipse(bullet.x*w_scale-camera_x*w_scale, bullet.y*w_scale-camera_y*w_scale, bullet.size*w_scale*0.5, bullet.size*w_scale*0.5);
  }
}

void fillers_move()
{
  for(int i=0;i<Fillers.size();i++)
  {
    Filler filler= Fillers.get(i);
    if(sqrt((filler.t_x-filler.x)*(filler.t_x-filler.x)+(filler.t_y-filler.y)*(filler.t_y-filler.y))<filler.speed)
    {
      int x=(int)filler.t_x/10;
      int y=(int)filler.t_y/10;
      for(int i2=-filler.size;i2<=filler.size;i2++)
      {
        for(int i3=-filler.size;i3<=filler.size;i3++)
        {
          if(x+i2>=0 && x+i2<100 && y+i3>=0 && y+i3<100)
          {
            grid[x+i2][y+i3]=1;
          }
        }
      }
      Fillers.remove(i);
      i--;
    }
    else
    {
      filler.x+=filler.speed*(filler.t_x-filler.x)/(abs(filler.t_x-filler.x)+abs(filler.t_y-filler.y));
      filler.y+=filler.speed*(filler.t_y-filler.y)/(abs(filler.t_x-filler.x)+abs(filler.t_y-filler.y));
    }
  }
}

void fillers_draw()
{
  stroke(0);
  strokeWeight(1*w_scale);
  fill(100);
  for(int i=0;i<Fillers.size();i++)
  {
    Filler filler=Fillers.get(i);
    int draw_size=filler.size+4;
    rect(w_scale*(filler.x-draw_size/2-camera_x),w_scale*(filler.y-draw_size/2-camera_y),w_scale*draw_size*2,w_scale*draw_size*2);
  }
}

void pickups_update()
{
  for(int i=0;i<Pickups.size();i++)
  {
    Pickup pickup=Pickups.get(i);
    pickup.life--;
    if(sqrt((pickup.x-player_x)*(pickup.x-player_x)+(pickup.y-player_y)*(pickup.y-player_y))<15)
    {
      switch (pickup.type)
      {
        case 0:
          player_health+=25;
          Pickups.remove(i);
          i--;
          break;
        case 1:
          ammo=10;
          ammo_type=1;
          Pickups.remove(i);
          i--;
          break;
        case 2:
          ammo=100;
          ammo_type=2;
          Pickups.remove(i);
          i--;
          break;
        case 3:
          ammo=60;
          ammo_type=3;
          Pickups.remove(i);
          i--;
          break;
      }
    }
    if(pickup.life<=0)
    {
      Pickups.remove(i);
      i--;
    }
  }
}

void pickups_draw()
{
  for(int i=0;i<Pickups.size();i++)
  {
    Pickup pickup=Pickups.get(i);
    float p_scale=1+0.2f*sin(pickup.life*PI/30.0f);
    strokeWeight(2*w_scale);
    stroke(0);
    fill(255);
    rect((pickup.x-10*p_scale-camera_x)*w_scale,(pickup.y-10*p_scale-camera_y)*w_scale,20*w_scale*p_scale,20*w_scale*p_scale);
    switch (pickup.type)
    {
      case 0:
        stroke(255,100,100);
        fill(255,100,100);
        rect((pickup.x-3*p_scale-camera_x)*w_scale,(pickup.y-7*p_scale-camera_y)*w_scale,6*w_scale*p_scale,14*w_scale*p_scale);
        rect((pickup.x-7*p_scale-camera_x)*w_scale,(pickup.y-3*p_scale-camera_y)*w_scale,14*w_scale*p_scale,6*w_scale*p_scale);
        break;
      case 1:
        fill(255,0,0);
        ellipse((pickup.x-camera_x)*w_scale,(pickup.y-camera_y)*w_scale,7*p_scale*w_scale,7*p_scale*w_scale);
        break;
      case 2:
        fill(255,200,0);
        ellipse((pickup.x-camera_x)*w_scale,(pickup.y-camera_y)*w_scale,7*p_scale*w_scale,7*p_scale*w_scale);
        break;
      case 3:
        fill(0,255,0);
        ellipse((pickup.x-camera_x)*w_scale,(pickup.y-camera_y)*w_scale,7*p_scale*w_scale,7*p_scale*w_scale);
        break;
    }
  }
}

void knockback(float x, float y, float mag)
{
  float dx=x-player_x;
  float dy=y-player_y;
  float theta=atan(dy/dx);
  if (dx>=0)
  {
    player_vx-=mag*cos(theta);
    player_vy-=mag*sin(theta);
  } else
  {
    player_vx+=mag*cos(theta);
    player_vy+=mag*sin(theta);
  }
}

boolean terrain_collide(float x1, float y1, float x2, float y2)
{
  if (point_collide(x1, y1) || point_collide(x1, y2) || point_collide(x2, y1) || point_collide(x2, y2))
  {
    return true;
  }

  for (float i=x1; i<x2; i+=10)
  {
    if (point_collide(i, y1) || point_collide(i, y2))
    {
      return true;
    }
  }
  for (float i=y1; i<y2; i+=10)
  {
    if (point_collide(x1, i) || point_collide(x1, i))
    {
      return true;
    }
  }

  return false;
}

boolean point_collide(float x, float y)
{
  int grid_x=(int)(x/10);
  int grid_y=(int)(y/10);
  if (grid_x<0)
  {
    grid_x=0;
  }
  if (grid_y<0)
  {
    grid_y=0;
  }
  if (grid_x>99)
  {
    grid_x=99;
  }
  if (grid_y>99)
  {
    grid_y=99;
  }
  return grid[grid_x][grid_y]==1;
}

void explode(float x, float y, float size)
{
  int grid_x=(int)x/10;
  int grid_y=(int)y/10;
  int grid_size=(int)size/20;
  for (int i=-grid_size; i<=grid_size; i++)
  {
    for (int i2=-grid_size; i2<=grid_size; i2++)
    {
      if (grid_x+i>=0 && grid_x+i<100 && grid_y+i2>=0 && grid_y+i2<100)
      {
        grid[grid_x+i][grid_y+i2]=0;
      }
    }
  }
}

void tutorial_update()
{
  switch(tutorial)
  {
  case 0:
    tutorial_step++;
    fill(0,0,0,max(0,(tutorial_step-30)*8));
    text("Hi. This is you.",(player_x-camera_x)*w_scale,(player_y-camera_y-50)*w_scale);
    if(tutorial_step>120)
    {
      fill(0,0,0,max(0,(tutorial_step-120)*8));
      text("Use WASD to move.",(player_x-camera_x)*w_scale,(player_y-camera_y+50)*w_scale);
    }
    if(tutorial_step>240)
    {
      tutorial=1;
      tutorial_step=0;
    }
    PlayerBullets=new ArrayList<PlayerBullet>();
    break;
  case 1:
    tutorial_step++;
    if(tutorial_step==1)
    {
      Pickups.add(new Pickup(800,900,0));
    }
    else
    {
      if(Pickups.size()>0)
      {
        Pickup pickup=Pickups.get(0);
        pickup.life=1000;
        fill(0,0,0,max(0,(tutorial_step-30)*8));
        text("This is a pickup.",(pickup.x-camera_x)*w_scale,(pickup.y-camera_y-50)*w_scale);
        if(tutorial_step>60)
        {
          fill(0,0,0,max(0,(tutorial_step-120)*8));
          text("Pick it up.",(pickup.x-camera_x)*w_scale,(pickup.y-camera_y+50)*w_scale);
        }
      }
      else
      {
        tutorial=2;
        tutorial_step=0;
      }
    }
    PlayerBullets=new ArrayList<PlayerBullet>();
    break;
  case 2:
    tutorial_step++;
    fill(0,0,0,max(0,(tutorial_step-30)*8));
    text("Left Click to shoot.",(player_x-camera_x)*w_scale,(player_y-camera_y-50)*w_scale);
    if(tutorial_step>120)
    {
      fill(0,0,0,max(0,(tutorial_step-120)*8));
      text("Shoot this dude when\nyou're ready to start.",(boss_x-camera_x)*w_scale,(boss_y-camera_y+150)*w_scale);
    }
    if(boss_phase!=-1)
    {
      tutorial=3;
      tutorial_step=0;
    }
    break;
  case 3:
    tutorial_step++;
    fill(0,0,0,max(0,(tutorial_step-10)*8));
    text("Good luck.",(boss_x-camera_x)*w_scale,(boss_y-camera_y+150)*w_scale);
    if(tutorial_step>90)
    {
      tutorial=-1;
    }
  }
}

class PlayerBullet
{
  float x;
  float y;
  float vx;
  float vy;
  int type;

  public PlayerBullet(float b_x, float b_y, float b_vx, float b_vy, int b_type)
  {
    x=b_x;
    y=b_y;
    vx=b_vx;
    vy=b_vy;
    type=b_type;
  }
}

class Explosion
{
  float x;
  float y;
  int r;
  int g;
  int b;
  float size;
  int age;
  int damage;
  boolean friendly;

  public Explosion(float e_x, float e_y, int e_r, int e_g, int e_b, float e_size, int e_damage, boolean e_friendly)
  {
    x=e_x;
    y=e_y;
    r=e_r;
    g=e_g;
    b=e_b;
    size=e_size;
    damage=e_damage;
    friendly=e_friendly;
  }
}

class BossBullet
{
  float x;
  float y;
  float vx;
  float vy;
  float ax;
  float ay;
  float drag;
  float size;
  int r;
  int g;
  int b;
  int damage;

  float explosion_size;
  int explosion_r;
  int explosion_g;
  int explosion_b;


  public BossBullet(float p_x, float p_y, float p_vx, float p_vy, float p_size, int p_damage)
  {
    x=p_x;
    y=p_y;
    vx=p_vx;
    vy=p_vy;
    size=p_size;
    damage=p_damage;
    ax=0;
    ay=0;
    drag=1;
    r=255;
    g=0;
    b=0;
    explosion_size=p_size*2;
    explosion_r=255;
    explosion_g=0;
    explosion_b=0;
  }
}

class Filler
{
  float x;
  float y;
  float t_x;
  float t_y;
  float speed;
  int size;
  public Filler(float f_x,float f_y,float f_t_x,float f_t_y,float f_speed, int f_size)
  {
    x=f_x;
    y=f_y;
    t_x=f_t_x;
    t_y=f_t_y;
    speed=f_speed;
    size=f_size;
  }
}

class Pickup
{
  float x;
  float y;
  int type;
  int life;
  public Pickup(float p_x,float p_y, int p_type)
  {
    x=p_x;
    y=p_y;
    type=p_type;
    life=600;
  }
}