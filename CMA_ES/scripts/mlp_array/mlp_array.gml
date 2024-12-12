// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function mlp_array(layerSizeArray, activationFunctionsArray) constructor {
    #region /// INITIALIZE NETWORK - Neurons, weights and biases.
    session = 0;
    layerCount = array_length(layerSizeArray); // число слоёв
    layerSizes = array_create(layerCount); // число нейронов в слое
    array_copy(layerSizes, 0, layerSizeArray, 0, layerCount);

    // Initialize neurons + their deltas.
    activity = []; // активации нейронов
    output = [];
    bias = []; // нейроны смещения
    delta = []; // Разница между фактическим выходом и желаемым результатом. Рассчитано из текущего примера
    timestep = 0; // служит для усиления моментов в оптимизаторах (SGD, Adam и т.д.)

    for (var i = 0; i < layerCount; i++) {
        activity[i] = array_create(layerSizes[i]);
        output[i] = array_create(layerSizes[i]);
        delta[i] = array_create(layerSizes[i]);
        bias[i] = array_create(layerSizes[i]);
        for (var j = 0; j < layerSizes[i]; j++) {
            bias[i][j] = random_range(-0.2, 0.2);
        }
    }

    // Initialize weights and gradients
    weights = [];
    gradients = [];
    for (var i = 1; i < layerCount; i++) {
        weights[i] = [];
        gradients[i] = [];
        for (var j = 0; j < layerSizes[i]; j++) {
            weights[i][j] = array_create(layerSizes[i - 1]);
            gradients[i][j] = array_create(layerSizes[i - 1]);
            for (var k = 0; k < layerSizes[i - 1]; k++) {
                weights[i][j][k] = random_range(-0.5, 0.5); // Give default random weight.
            }
        }
    }

	    // Initialize activation functions
    if (array_length(activationFunctionsArray) != layerCount - 1) {
        show_error("Количество функций активации должно соответствовать количеству слоев, за исключением входного слоя.", true);
    }
	
    activationFunctions = array_create(layerCount - 1);
    activationFunctionsDerivative = array_create(layerCount - 1);
    array_copy(activationFunctions, 0, activationFunctionsArray, 0, layerCount - 1);

    // Заполняем соответствующими производными
    for (var i = 0; i < layerCount - 1; i++) {
        switch(activationFunctions[i]) {
            case Tanh:
                activationFunctionsDerivative[i] = TanhDerivative;
                break;
            case Relu:
                activationFunctionsDerivative[i] = ReluDerivative;
                break;
            case LeakyReLU:
                activationFunctionsDerivative[i] = LeakyReLUDerivative;
                break;
            case Sigmoid:
                activationFunctionsDerivative[i] = SigmoidDerivative;
                break;
            default:
                show_error("Неизвестная функция активации.", true);
        }
    }
    #endregion

    /// @func Forward
    /// @desc Выполняет прямое распространение через сеть
    /// @param {array} inputData - входные данные для сети
    /// @return {array} - выходные данные сети
static Forward = function (inputData) {
    // Проверяем, совпадает ли размер входных данных с размером первого слоя
    if (array_length(inputData) != layerSizes[0]) {
        show_error("Размер входных данных не совпадает с размером первого слоя", true);
    }

    // Устанавливаем входные данные как выходные данные первого слоя
    array_copy(output[0], 0, inputData, 0, array_length(inputData));

    // Прямое распространение через каждый слой
    for (var i = 1; i < layerCount; i++) {
        for (var j = 0; j < layerSizes[i]; j++) {
            activity[i][j] = 0; // Инициализируем сумму активности для нейрона

            for (var k = 0; k < layerSizes[i - 1]; k++) {
                // Суммируем взвешенные входные данные
                activity[i][j] += output[i - 1][k] * weights[i][j][k];
            }
            
            // Применяем соответствующую функцию активации к сумме активностей + смещение
            output[i][j] = activationFunctions[i - 1](activity[i][j] + bias[i][j]);
        }
    }

    // Возвращаем выходной массив последнего слоя
    return output[layerCount - 1];
}

static Output = function() {
    return output[layerCount - 1]; // Возвращаем выходные данные последнего слоя
}


    /// @func CopyParameters
    /// @desc Копирует параметры (веса и bias) из другой нейронной сети
    /// @param {mlp_array} sourceNetwork - исходная сеть, откуда копируются параметры
    static CopyParameters = function (sourceNetwork) {
        //if (layerCount != sourceNetwork.layerCount) {
        //    show_error("Сети имеют разное количество слоёв. Копирование невозможно.", true);
        //}
        for (var i = 1; i < layerCount; i++) {
            //if (layerSizes[i] != sourceNetwork.layerSizes[i] || layerSizes[i - 1] != sourceNetwork.layerSizes[i - 1]) {
            //    show_error("Сети имеют разные размеры слоёв. Копирование невозможно.", true);
            //}
             //Копируем веса
            for (var j = 0; j < layerSizes[i]; j++) {
                array_copy(weights[i][j], 0, sourceNetwork.weights[i][j], 0, layerSizes[i - 1]);
				
            }
             //Копируем bias
            array_copy(bias[i], 0, sourceNetwork.bias[i], 0, layerSizes[i]);

			
        }

    };



}




//// Функция награды
// Чем ближе агент к цели по осям x и y, тем выше награда
function rewardFunction(pos_agent, pos_goal) {
    var distance_x = abs(pos_agent[0] - pos_goal[0]); // расстояние по оси x
    var distance_y = abs(pos_agent[1] - pos_goal[1]); // расстояние по оси y

    // Общая дистанция как евклидово расстояние
    var distance = sqrt(distance_x * distance_x + distance_y * distance_y);

    // Максимальное расстояние - диагональ прямоугольной области (комнаты)
    var max_distance = sqrt(room_width * room_width + room_height * room_height);

    // Награда: чем ближе агент к цели, тем выше награда (от 0 до 1)
    var reward = (max_distance - distance) / max_distance;
    return reward;
}
	


function Restart() {
    // Обнуляем награды и временные шаги
    total_reward = 0;
    timestep = 0;

    // Начальное состояние
    x = x_position_agent_start;
	y = y_position_agent_start;
	

    // Очистка памяти
    memory.clear();
	
	policy_network.timestep=0//служит для разгона оптимизаторов 
	value_network.timestep=0//служит для разгона оптимизаторов 

	//with obj_target //чтобы цель появлялась в разных местах
	//{
	//	x=random(room_width)
	//	y=random(room_height)
	//}
}

