#include <vector>
#include <cstdio>
#include <cassert>
#include <list>

#include "astar.h"
#include "visualizer.h"

struct Check{
	int x;
	int y;
	int timer;
};


using namespace std;

int main() {
    Point mapSize;
    vector< vector< bool > > obstacle;
    Point A, B, target;
    int timeA=1;
    int timeB=1;
    int TimeToTarget;
    int TimeToTargetB;
    //reading map size
    scanf( "%i %i\n",&mapSize.x, &mapSize.y);
    //reading robotA coordinates
    scanf("%i %i\n",&A.x,&A.y);	
    //reading robotB coordinates
    scanf("%i %i\n",&B.x,&B.y);
    //reading final target coordinates
    scanf("%i %i\n",&target.x,&target.y);
    // make coordinates 0-based as our arrays are
    --A.x; --A.y; --B.x; --B.y; --target.x; --target.y;
    //verifications
    assert( mapSize.x > 0 );
    assert( mapSize.y > 0 );
    assert( mapSize.x <= 400000 );
    assert( mapSize.y <= 400000 );
    assert( validPoint( A, mapSize ) );
    assert( validPoint( B, mapSize ) );
    assert( validPoint( target, mapSize ) );
    //reading the number of mid-route points
    int k;
    scanf("%i\n",&k);
    Point P[k];
    int i;
    //reading the mid-route points
    for(i=0;i<k;i++){
    	scanf("%i %i\n",&P[i].x,&P[i].y);
    	P[i].x--;
    	P[i].y--; //make coordinates 0-based as our arrays are
    	assert(validPoint(P[i],mapSize));//verifications
    }

    for ( int x = 0; x < mapSize.x; ++x ) {
        obstacle.push_back( vector< bool >( mapSize.y ) ); //memory allocation for my vector obstacle array 2d
    }

    for ( int y = 0; y < mapSize.y; ++y ) {
        for ( int x = 0; x < mapSize.x; ++x ) {
            // make sure we have allocated this cell's memory correctly
            assert( obstacle[ x ][ y ] || !obstacle[ x ][ y ] );
            char c;
            scanf( "%c", &c );
            assert( c == 'X' || c == 'O' ); //check if our input is correct
            obstacle[ x ][ y ] = (c == 'X'); //0 -> free space , 1 -> obstacle
        }
        scanf( "\n" );
    }
    // make sure the robots start from an empty square position and that the target and mid-route destinations
    // are free squares as well
    assert( !obstacle[ target.x ][ target.y ] );
    assert( !obstacle[ A.x ][ A.y ] );
    assert( !obstacle[ B.x ][ B.y ] );
    for(i=0;i<k;i++){
    	assert(!obstacle[P[i].x][P[i].y]);
    }
    Point lastEndA,lastEndB;
    list< Edge > APath,BPath;
    list <struct Check> temp;
    list <struct Check> temp2;
    Point prev;
    //i am done with reading
    //lets start looking for paths
    //if we are about to have collisions stall B at his own place till the robot A leaves
    //we will calculate A robot whole path
    //A route calculator
    struct Check helper;
    for (i=0;i<k;i++){
    	if(i==0){
    		APath= aStar(P[0],A,obstacle,mapSize);
    		for ( list< Edge >::iterator it = APath.begin(); it != APath.end(); ++it ) {
			helper.x=it->from.x;
			helper.y=it->from.y;
			helper.timer=timeA;
			temp.push_back(helper);
			timeA++;	
			if (it->from == P[0])
				break;		
		}
    	}
    	else{
    		APath = aStar(P[i],P[i-1],obstacle,mapSize);
    		for ( list< Edge >::iterator it = APath.begin(); it != APath.end(); ++it ) {
			helper.x=it->from.x;
			helper.y=it->from.y;
			helper.timer=timeA;
			temp.push_back(helper);
			timeA++;
			if (it->from == P[i])
				break;			
		}
    	}
    }
    APath = aStar(target,P[k-1],obstacle,mapSize);
    for ( list< Edge >::iterator it = APath.begin(); it != APath.end(); ++it ) {
	helper.x=it->from.x;
	helper.y=it->from.y;
	helper.timer=timeA;
	temp.push_back(helper);
	timeA++;
	if(it->from==target){
		TimeToTarget=timeA-1;
		break;
	}
    }
    APath = aStar(A,target,obstacle,mapSize);
    for ( list< Edge >::iterator it = APath.begin(); it != APath.end(); ++it ) {
	helper.x=it->from.x;
	helper.y=it->from.y;
	helper.timer=timeA;
	temp.push_back(helper);
	timeA++;
	if(it->from==A)
		break;
    }
    
    
    //B route calculator
    for (i=0;i<k;i++){
    	if(i==0){
    		BPath= aStar(P[0],B,obstacle,mapSize);
    		for ( list< Edge >::iterator it = BPath.begin(); it != BPath.end(); ++it ) {
			helper.x=it->from.x;
			helper.y=it->from.y;
			helper.timer=timeB;
			temp2.push_back(helper);
			timeB++;	
			if (it->from == P[0])
				break;		
		}
    	}
    	else{
    		BPath = aStar(P[i],P[i-1],obstacle,mapSize);
    		for ( list< Edge >::iterator it = BPath.begin(); it != BPath.end(); ++it ) {
			helper.x=it->from.x;
			helper.y=it->from.y;
			helper.timer=timeB;
			temp2.push_back(helper);
			timeB++;
			if (it->from == P[i])
				break;			
		}
    	}
    }
    BPath = aStar(target,P[k-1],obstacle,mapSize);
    for ( list< Edge >::iterator it = BPath.begin(); it != BPath.end(); ++it ) {;
	helper.x=it->from.x;
	helper.y=it->from.y;
	helper.timer=timeB;
	temp2.push_back(helper);
	timeB++;
	if(it->from==target){
		TimeToTargetB=timeB-1;
		break;
	}
    }
    BPath = aStar(B,target,obstacle,mapSize);
    for ( list< Edge >::iterator it = BPath.begin(); it != BPath.end(); ++it ) {;
	helper.x=it->from.x;
	helper.y=it->from.y;
	helper.timer=timeB;
	temp2.push_back(helper);
	timeB++;
	if(it->from==B)
		break;
    }
    
    
    //we have calculated A and B route
    //now we will find out B route avoiding collisions with A, we will stall B robot for 1 moment to avoid this collision
    //and wait at target for robot A to come
    timeA--;
    timeB--;
if (TimeToTarget > TimeToTargetB){
    //so as to pop as many elements from list as we can
    //i will pop elements only when timeB<=timeA
    printf( "Robot A path:\n" );
    for ( list< struct Check >::iterator it = temp.begin(); it != temp.end(); ++it ) {
    	printf("(%i, %i) at moment:%i\n",it->x +1 ,it->y +1 ,it->timer);
    }
    timeB=1;
    for (i=0;i<k;i++){
    	if(i==0){
    		BPath= aStar(P[0],B,obstacle,mapSize);
    		printf( "Robot B path:\n" );
    		prev=BPath.begin()->from;
    		for ( list< Edge >::iterator it = BPath.begin(); it != BPath.end(); ++it ) {
			if(timeA > timeB){
				helper=temp.front();
				temp.pop_front();
				if (helper.x==it->from.x && helper.y==it->from.y && helper.timer==timeB){ //collision,stay where you were mr B
					printf("Collision Happens, so MR. B waits here for a moment\n");
					printf( "(%i, %i) at moment:%i\n", prev.x + 1, prev.y + 1,timeB );
					--it;//to remain at the same element				
				}
				else{
				printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeB );
				prev=it->from;
				}
			}
			else{
				printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeB );
				prev=it->from;
			}
			timeB++;	
			if (it->from == P[0])
				break;		
		}
    	}
    	else{
    		BPath= aStar(P[i],P[i-1],obstacle,mapSize);
    		prev=BPath.begin()->from;
    		for ( list< Edge >::iterator it = BPath.begin(); it != BPath.end(); ++it ) {
			if(timeA > timeB){
				helper=temp.front();
				temp.pop_front();
				if (helper.x==it->from.x && helper.y==it->from.y && helper.timer==timeB){ //collision,stay where you were mr B
					printf("Collision Happens, so MR. B waits here for a moment\n");
					printf( "(%i, %i) at moment:%i\n", prev.x + 1, prev.y + 1,timeB );
					--it;//to remain at the same element				
				}
				else{
				printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeB );
				prev=it->from;
				}
			}
			else{
				printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeB );
				prev=it->from;
			}
			timeB++;	
			if (it->from == P[i])
				break;		
		}
    	}
       
     }
    BPath = aStar(target,P[k-1],obstacle,mapSize);
    prev=BPath.begin()->from;
    for ( list< Edge >::iterator it = BPath.begin(); it != BPath.end(); ++it ) {
	if (it->from == target){
		while (timeB<=TimeToTarget){ //B waits for A to come at the target
			printf( "(%i, %i) at moment:%i\n", prev.x + 1, prev.y + 1,timeB );
			timeB++;
		}
		break;
	}
	if(timeA > timeB){
		helper=temp.front();
		temp.pop_front();
		if (helper.x==it->from.x && helper.y==it->from.y && helper.timer==timeB){ //collision,stay where you were mr B
			printf("Collision Happens, so MR. B waits here for a moment\n");
			printf( "(%i, %i) at moment:%i\n", prev.x + 1, prev.y + 1,timeB );
			--it;//to remain at the same element				
		}
		else{
		printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeB );
		prev=it->from;
		}
	}
	else{
		printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeB );
		prev=it->from;
	}
	timeB++;	
	if (it->from == target)
		break;
    }
    BPath = aStar(B,prev,obstacle,mapSize);
    prev=BPath.begin()->from;
    for ( list< Edge >::iterator it = BPath.begin(); it != BPath.end(); ++it ) {
	if (timeA > timeB){
		helper=temp.front();
		temp.pop_front();
		if (helper.x==it->from.x && helper.y==it->from.y && helper.timer==timeB){ //collision,stay where you were mr B
			printf("Collision Happens, so MR. B waits here for a moment\n");
			printf( "(%i, %i) at moment:%i\n", prev.x + 1, prev.y + 1,timeB );
			--it;//to remain at the same element				
		}
		else{
		printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeB );
		prev=it->from;
		}
	}	
	else{
		printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeB );
		prev=it->from;
	}
	timeB++;	
	if (it->from == B)
		break;
   } 
}  




if (TimeToTarget <= TimeToTargetB){
    //so as to pop as many elements from list as we can
    //i will pop elements only when timeB<=timeA
    printf( "Robot B path:\n" );
    for ( list< struct Check >::iterator it = temp2.begin(); it != temp2.end(); ++it ) {
    	printf("(%i, %i) at moment:%i\n",it->x +1 ,it->y +1 ,it->timer);
    }
    timeA=1;
    for (i=0;i<k;i++){
    	if(i==0){
    		APath= aStar(P[0],A,obstacle,mapSize);
    		printf( "Robot A path:\n" );
    		prev=APath.begin()->from;
    		for ( list< Edge >::iterator it = APath.begin(); it != APath.end(); ++it ) {
			if(timeA < timeB){
				helper=temp2.front();
				temp2.pop_front();
				if (helper.x==it->from.x && helper.y==it->from.y && helper.timer==timeA){ //collision,stay where you were mr A
					printf("Collision Happens, so MR. A waits here for a moment\n");
					printf( "(%i, %i) at moment:%i\n", prev.x + 1, prev.y + 1,timeA );
					--it;//to remain at the same element				
				}
				else{
				printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeA );
				prev=it->from;
				}
			}
			else{
				printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeA );
				prev=it->from;
			}
			timeA++;	
			if (it->from == P[0])
				break;		
		}
    	}
    	else{
    		APath= aStar(P[i],P[i-1],obstacle,mapSize);
    		prev=APath.begin()->from;
    		for ( list< Edge >::iterator it = APath.begin(); it != APath.end(); ++it ) {
			if(timeA < timeB){
				helper=temp2.front();
				temp2.pop_front();
				if (helper.x==it->from.x && helper.y==it->from.y && helper.timer==timeA){ //collision,stay where you were mr A
					printf("Collision Happens, so MR. A waits here for a moment\n");
					printf( "(%i, %i) at moment:%i\n", prev.x + 1, prev.y + 1,timeA );
					--it;//to remain at the same element				
				}
				else{
				printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeA );
				prev=it->from;
				}
			}
			else{
				printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeA );
				prev=it->from;
			}
			timeA++;	
			if (it->from == P[i])
				break;		
		}
    	}
       
     }
    APath = aStar(target,P[k-1],obstacle,mapSize);
    prev=APath.begin()->from;
    for ( list< Edge >::iterator it = APath.begin(); it != APath.end(); ++it ) {
	if (it->from == target){
		while (timeA<=TimeToTargetB){ //A waits for B to come at the target
			printf( "(%i, %i) at moment:%i\n", prev.x + 1, prev.y + 1,timeB );
			timeA++;
		}
		break;
	}
	if(timeA < timeB){
		helper=temp2.front();
		temp2.pop_front();
		if (helper.x==it->from.x && helper.y==it->from.y && helper.timer==timeA){ //collision,stay where you were mr A
			printf("Collision Happens, so MR. A waits here for a moment\n");
			printf( "(%i, %i) at moment:%i\n", prev.x + 1, prev.y + 1,timeA );
			--it;//to remain at the same element				
		}
		else{
		printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeA );
		prev=it->from;
		}
	}
	else{
		printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeA );
		prev=it->from;
	}
	timeA++;	
	if (it->from == target)
		break;
    }
    APath = aStar(A,prev,obstacle,mapSize);
    prev=APath.begin()->from;
    for ( list< Edge >::iterator it = APath.begin(); it != APath.end(); ++it ) {
	if (timeA < timeB){
		helper=temp2.front();
		temp2.pop_front();
		if (helper.x==it->from.x && helper.y==it->from.y && helper.timer==timeA){ //collision,stay where you were mr A
			printf("Collision Happens, so MR. A waits here for a moment\n");
			printf( "(%i, %i) at moment:%i\n", prev.x + 1, prev.y + 1,timeA );
			--it;//to remain at the same element				
		}
		else{
		printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeA );
		prev=it->from;
		}
	}	
	else{
		printf( "(%i, %i) at moment:%i\n", it->from.x + 1, it->from.y + 1,timeA );
		prev=it->from;
	}
	timeA++;	
	if (it->from == A)
		break;
   } 
}   
  
    printf( "\n" );

    visualize( APath, BPath, obstacle, mapSize );

    return 0;
}
