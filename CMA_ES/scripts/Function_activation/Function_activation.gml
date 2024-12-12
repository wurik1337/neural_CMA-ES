// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information



#region function activation 
/// @func Tanh
/// @desc Активационная функция гиперболический тангенс
/// @param {real} x - входное значение
/// @return {real} - результат функции tanh
function Tanh(x) {
	var i=(exp(2 * x) - 1) / (exp(2 * x) + 1);
		if is_nan(i)
	show_message("NAN Tanhactiv "+string(x)+string(i))
    return i;
}
	
/// @func TanhDerivative
/// @desc Производная функции активации tanh
/// @param {real} x - входное значение
/// @return {real} - значение производной tanh
function TanhDerivative(x) {
    var tanhX = Tanh(x);
	//if sqr(tanhX)!=0
	//show_message(sqr(tanhX))
	if is_nan(sqr(tanhX))
	show_message("NAN TanhDerivative "+string(tanhX))
    return 1 - sqr(tanhX);
}
	
/// @func Sigmoid
/// @desc Функция активации Sigmoid
/// @param {real} x - входное значение
/// @return {real} - результат функции Sigmoid
function Sigmoid(x) {
	return 1 / (1 + exp(-x));
}

/// @func SigmoidDerivative
/// @desc Производная функции активации Sigmoid
/// @param {real} x - входное значение
/// @return {real} - значение производной Sigmoid
function SigmoidDerivative(x) {
	var sigmoid = Sigmoid(x);
	return sigmoid * (1 - sigmoid);
}

/// @func Relu
/// @desc Функция активации Relu
/// @param {real} x - входное значение
/// @return {real} - результат функции ReLU
function Relu(x) {
	return max(0, x);
}

/// @func ReluDerivative
/// @desc Производная функции активации ReLU
/// @param {real} x - входное значение
/// @return {real} - значение производной ReLU
function ReluDerivative(x) {
	return (x > 0);
}

/// @func LeakyReLU
/// @desc Функция активации Leaky ReLU
/// @param {real} x - входное значение
/// @param {real} alpha - коэффициент утечки
/// @return {real} - результат функции Leaky ReLU
function LeakyReLU(x) {
    return (x >= 0) ? x : 0.01 * x;
}

/// @func LeakyReLUDerivative
/// @desc Производная функции активации Leaky ReLU
/// @param {real} x - входное значение
/// @param {real} alpha - коэффициент утечки
/// @return {real} - значение производной Leaky ReLU
function LeakyReLUDerivative(x) {
    return (x >= 0) ? 1 : 0.01;
}
#endregion

/// @func Softmax
/// @desc Функция активации Softmax
/// @param {array} x - массив входных значений
/// @return {array} - массив вероятностей
function Softmax(x) {
    var expSum = 0;
    var expValues = array_create(array_length(x));
    
    // Вычисляем экспоненты входных значений и их сумму
    for (var i = 0; i < array_length(x); i++) {
        expValues[i] = exp(x[i]);
        expSum += expValues[i];
    }

    // Нормализуем экспоненты, чтобы получить вероятности
    for (var i = 0; i < array_length(x); i++) {
        expValues[i] /= expSum;
    }

    return expValues;
}

///////!!!Важно (SoftmaxDerivative) толком не используется
/// @func SoftmaxDerivative
/// @desc Вычисляет производную softmax функции
/// @param {array} output - выходы softmax для текущего примера
/// @return {array} - матрица Якоби softmax, сжатая до градиента для текущего слоя
function SoftmaxDerivative(output) {
    var length = array_length(output);
    var jacobian = [];

    for (var i = 0; i < length; i++) {
        jacobian[i] = array_create(length);
        for (var j = 0; j < length; j++) {
            if (i == j) {
                jacobian[i][j] = output[i] * (1 - output[i]);
            } else {
                jacobian[i][j] = -output[i] * output[j];
            }
        }
    }

    return jacobian;
}

/// @func ArgMax
/// @desc Возвращает индекс максимального элемента в массиве
/// @param {array} array - массив чисел
/// @return {real} - индекс максимального элемента
function ArgMax(array) {
    var maxIndex = 0;
    for (var i = 1; i < array_length(array); i++) {
        if (array[i] > array[maxIndex]) {
            maxIndex = i;
        }
    }
    return maxIndex;
}

function array_clear(array) {
	return array_delete(array, 0, array_length(array));
}

function proximity_value(obj1, obj2, max_distance) {
    // Вычисляем расстояние между объектами
    var dist = distance_to_object(obj2);//point_distance(obj1.x, obj1.y, obj2.x, obj2.y);
    
    // Нормализуем значение расстояния в диапазон от 0 до 1
    var norm_dist = clamp(dist / max_distance, 0, 1);
    
    // Инвертируем значение, чтобы ближе к 0 было ближе к объекту
    return 1 - norm_dist;
}