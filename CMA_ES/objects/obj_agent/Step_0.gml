/// @description Insert description here
// You can write your code in this editor
var inputData = [obj_target.x/room_width,obj_target.y/room_height,x/room_width,y/room_height]
var output=network.Forward(inputData);
x+=output[@ 0]
y+=output[@ 1]


if (dead)// Fell down.
{
	//fitness -= 1000;
	instance_deactivate_object(self);
	dead=false
}

reward=ceil(proximity_value(self,obj_target,2000)*100)


///// @description ENEMY DISTANCE

//var _radius = 120

//var _left = 1
//var _right = 1
//var _down = 1
//var _up = 1

//var _x = x 
//var _y = y

//with (obj_enemy) {
//    var _dist = point_distance(x, y, _x, _y)
    
//    if (_dist < _radius) {
        
//        var _angle = -1 
//        var _angleDiffMax = 360
//        var _dir = point_direction( _x, _y, x, y)
//        var _angleParts = 4
//        var _anglePartCount = 360 / _angleParts
//        var _len = _dist / _radius
        
//        for ( var i = 0; i < _angleParts; i++) {
//            var _angleDiff = abs(angle_difference(_dir, _anglePartCount * i))
            
//            if (_angleDiff < _angleDiffMax) {
//                _angle = i
//                _angleDiffMax = _angleDiff
//            }
//        }
        
//        switch (_angle) {
//            case 1:
//                if _up > _len 
//                    _up = _len
//            break;
            
//            case 2:
//                if _left > _len 
//                    _left = _len
//            break;
            
//            case 3:
//                if _down > _len 
//                    _down = _len
//            break;
            
//            default:
//                if _right > _len 
//                    _right = _len
//            break;
//        }//switch
        
//        //show_debug_message(string("angle{0}, angleDiff:{1}", _angle, _angleDiff))
//    }
    
//}


////присваеваем значения итоговые
//Lleft = _left
//Rright = _right
//Ttop = _up
//Ddown = _down