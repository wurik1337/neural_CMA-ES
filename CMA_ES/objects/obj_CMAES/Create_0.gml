/// @desc Гиперпараметры , сети и тп
randomize()

//сортирует объекты по награде
/// @func	neural_genetic_selection(population);
/// @desc	Sorts population by their fitness-scoring, assumes higher score is better.
/// @param	{array}		population		Array of structs/instances.
function neural_genetic_selection(population) {
	array_sort(population, function(A, B) {
		return B.reward - A.reward;
	});
}


function random_gaussian(men = 0, stddev = 1) {
    var u1 = random(1);
    var u2 = random(1);

    var z0 = sqrt(-2 * ln(u1)) * cos(2 * pi * u2);
    return men + z0 * stddev;
}

function MutateNetwork(network) {
    for (var i = 1; i < network.layerCount; i++) {
        for (var j = 0; j < network.layerSizes[i]; j++) {
            for (var k = 0; k < network.layerSizes[i - 1]; k++) {
                network.weights[i][j][k] += random_gaussian() * sigma;
            }
            network.bias[i][j] += random_gaussian() * sigma;
        }
    }
}


function UpdateMeanNetwork(agents, mean_network) {
    // Сортируем агентов по их наградам (от большего к меньшему)
    neural_genetic_selection(agents);
    // Определяем количество элитных агентов
    var top_agents_count = ceil(population_size * population_elite);

    // Обход всех слоёв сети
    for (var i = 1; i < mean_network.layerCount; i++) {
        for (var j = 0; j < mean_network.layerSizes[i]; j++) {
            // Обновляем веса
            for (var k = 0; k < mean_network.layerSizes[i - 1]; k++) {
                var weight_sum = 0;
                for (var t = 0; t < top_agents_count; t++) {
                    weight_sum += agents[t].network.weights[i][j][k];
                }
                mean_network.weights[i][j][k] = weight_sum / top_agents_count;
            }
            
            // Обновляем bias
            var bias_sum = 0;
            for (var t = 0; t < top_agents_count; t++) {
                bias_sum += agents[t].network.bias[i][j];
            }
            mean_network.bias[i][j] = bias_sum / top_agents_count;
        }
    }
}


function ResetAgents(agents) {
	
    for (var i = 0; i < population_size; i++) {
        var agent = agents[i];
        if (instance_exists(agent)) {

			agent.network.CopyParameters(mean_network)//копирует центральную сеть
            agent.reward = 0;
            agent.active = true;
			
			MutateNetwork(agent.network)
			agent.x=x+random_range(-45,45)
			agent.y=y+random_range(-45,45)
			obj_target.x=random_range(0,room_width)
			obj_target.y=random_range(0,room_height)
        }
    }
}

// Перезапуск симуляции
alarm[0] = 500; // Задержка для активации

/// Create Event
population_size = 25;
population_elite=0.1
agents = []; // Список агентов
fitness_scores = []; // Пригодность агентов

// Параметры CMA-ES
mean_network = new mlp_array([4, 5, 4, 2], [Tanh, Tanh, Tanh]); // Средняя сеть
sigma = 0.5; // Шаг изменения параметров

// Создание агентов
for (var i = 0; i < population_size; i++) {
    var agent = instance_create_depth(x+random_range(-25,25), y+random_range(-25,25),-1, obj_agent);
    agent.network = new mlp_array([4, 5, 4, 2], [Tanh, Tanh, Tanh]);
	agent.network.CopyParameters(mean_network)

	MutateNetwork(agent.network)
    agents[i] = agent;
}




