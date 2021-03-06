(*
 This code was created by Jeff Molofee '99
 If you've found this code useful, please let me know.

 The full tutorial associated with this file is available here:
 http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=02

 (OCaml version by Florent Monnier)
*)
open GL       (* Module For The OpenGL Library *)
open Glu      (* Module For The GLu Library *)
open Glut     (* Module For The GLUT Library *)

(* A general OpenGL initialization function.  Sets all of the initial parameters. *)
let initGL ~width ~height =                (* We call this right after our OpenGL window is created. *)
  glClearColor 0.0 0.0 0.0 0.0;            (* This Will Clear The Background Color To Black *)
  glClearDepth 1.0;                        (* Enables Clearing Of The Depth Buffer *)
  glDepthFunc GL_LESS;                     (* The Type Of Depth Test To Do *)
  glEnable GL_DEPTH_TEST;                  (* Enables Depth Testing *)
  glShadeModel GL_SMOOTH;                  (* Enables Smooth Color Shading *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();                        (* Reset The Projection Matrix *)

  gluPerspective 45.0 ((float width)/.(float height)) 0.1 100.0;  (* Calculate The Aspect Ratio Of The Window *)

  glMatrixMode GL_MODELVIEW;
;;

(* The function called when our window is resized (which shouldn't happen, because we're fullscreen) *)
let reshape ~width ~height =
  let height =
    if height = 0                          (* Prevent A Divide By Zero If The Window Is Too Small *)
    then 1
    else height
  in

  glViewport 0 0 width height;             (* Reset The Current Viewport And Perspective Transformation *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();

  gluPerspective 45.0 ((float width)/.(float height)) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;

(* The main drawing function. *)
let display() =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];  (* Clear The Screen And The Depth Buffer *)
  glLoadIdentity();                        (* Reset The View *)

  glTranslate (-1.5) (0.0) (-6.0);         (* Move Left 1.5 Units And Into The Screen 6.0 *)
        
  (* draw a triangle *)
  glBegin GL_POLYGON;                      (* start drawing a polygon *)
  glVertex3 ( 0.0) ( 1.0) (0.0);           (* Top *)
  glVertex3 ( 1.0) (-1.0) (0.0);           (* Bottom Right *)
  glVertex3 (-1.0) (-1.0) (0.0);           (* Bottom Left   *)
  glEnd();                                 (* we're done with the polygon *)

  glTranslate 3.0 0.0 0.0;                 (* Move Right 3 Units *)
        
  (* draw a square (quadrilateral) *)
  glBegin(GL_QUADS);                       (* start drawing a polygon (4 sided) *)
  glVertex3 (-1.0) ( 1.0) (0.0);           (* Top Left *)
  glVertex3 ( 1.0) ( 1.0) (0.0);           (* Top Right *)
  glVertex3 ( 1.0) (-1.0) (0.0);           (* Bottom Right *)
  glVertex3 (-1.0) (-1.0) (0.0);           (* Bottom Left *)
  glEnd();                                 (* done with the polygon *)

  (* swap buffers to display, since we're double buffered. *)
  glutSwapBuffers();
;;

(* The function called whenever a key is pressed. *)
let keyPressed ~window ~key ~x ~y =
  (* If escape or 'q' are pressed, kill everything. *)
  match key with
  | 'q' | '\027' ->
      (* shut down our window *)
      glutDestroyWindow window;
      
      (* exit the program...normal termination. *)
      exit(0);                   

  | _ -> ()
;;

let () =
  (* Initialize GLUT state - glut will take any command line arguments that
     pertain to it or X Windows - look at its documentation at:
     http://www.opengl.org/resources/libraries/glut/spec3/node10.html *)
  ignore(glutInit Sys.argv);

  (* Select type of Display mode:   
     Double buffer 
     RGBA color
     Alpha components supported 
     Depth buffer *)  
  glutInitDisplayMode [GLUT_RGBA; GLUT_DOUBLE; GLUT_ALPHA; GLUT_DEPTH];

  (* get a 640 x 480 window *)
  glutInitWindowSize 640 480;

  (* the window starts at the upper left corner of the screen *)
  glutInitWindowPosition 0 0;

  (* Open a window *)  
  let window =  (* The number of our GLUT window *)
    glutCreateWindow "Jeff Molofee's GL Code Tutorial ... NeHe '99"
  in

  (* Register the function to do all our OpenGL drawing. *)
  glutDisplayFunc ~display;

  (* Go fullscreen.  This is as soon as possible. *)
  glutFullScreen();

  (* Even if there are no events, redraw our gl scene. *)
  glutIdleFunc ~idle:display;

  (* Register the function called when our window is resized. *)
  glutReshapeFunc ~reshape;

  (* Register the function called when the keyboard is pressed. *)
  glutKeyboardFunc ~keyboard:(keyPressed ~window);

  (* Initialize our window. *)
  initGL 640 480;
  
  (* Start Event Processing Engine *)  
  glutMainLoop();  
;;

