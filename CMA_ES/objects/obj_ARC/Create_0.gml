/// @desc Гиперпараметры , сети и тп
randomize()

//сортирует объекты по награде
/// @func	neural_genetic_selection(population);
/// @desc	Sorts population by their fitness-scoring, assumes higher score is better.
/// @param	{array}		population		Array of structs/instances.
function neural_genetic_selection_ars(population) {
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

/// MutateNetwork(network)
function MutateNetworkArs(network, perturbation_scale) {
    for (var i = 1; i < network.layerCount; i++) {
        for (var j = 0; j < network.layerSizes[i]; j++) {
            for (var k = 0; k < network.layerSizes[i - 1]; k++) {
				
                network.weights[i][j][k] += random_gaussian(0, abs(perturbation_scale)) * sign(perturbation_scale);
            }
            network.bias[i][j] += random_gaussian(0, abs(perturbation_scale)) * sign(perturbation_scale);
        }
    }
};


function UpdateMeanNetwork(central_network, positive_agents, negative_agents, learning_rate,population_elite) { //(agents, mean_network) 
    neural_genetic_selection_ars(positive_agents);
	neural_genetic_selection_ars(negative_agents);
		// Возвращаем топ-агентов в соответствии с коэффициентом elite_ratio
    var elite_count = ceil(population_size * population_elite);

    // Обновляем параметры центральной сети
    for (var i = 1; i < central_network.layerCount; i++) {
        for (var j = 0; j < central_network.layerSizes[i]; j++) {
            for (var k = 0; k < central_network.layerSizes[i - 1]; k++) {
                // Градиент для обновления весов
                var weight_update = 0;
                for (var t = 0; t < elite_count; t++) {
                    weight_update += positive_agents[t].network.weights[i][j][k] -
                                     negative_agents[t].network.weights[i][j][k];
                }
                central_network.weights[i][j][k] += (learning_rate / elite_count) * weight_update;
            }

            // Градиент для обновления смещений (bias)
            var bias_update = 0;
            for (var t = 0; t < elite_count; t++) {
                bias_update += positive_agents[t].network.bias[i][j] -
                               negative_agents[t].network.bias[i][j];
            }
            central_network.bias[i][j] += (learning_rate / elite_count) * bias_update;
        }
    }
}




/// ResetAgents()
function ResetAgents(agents) {
	
    for (var i = 0; i < population_size; i++) {
        var agent = agents[i];
        if (instance_exists(agent)) {

			agent.network.CopyParameters(mean_network)//копирует центральную сеть
            agent.reward = 0;
            agent.active = true;
			
			agent.x=x+random_range(-45,45)
			agent.y=y+random_range(-45,45)
			//obj_target.x=random_range(0,room_width)
			//obj_target.y=random_range(0,room_height)
        }
    }
	
	for (var i = 0; i < population_size / 2; i++) {
	// Применяем случайную пертурбацию
	//show_message(positive_agents[i].network)
	//show_message(negative_agents[i].network)
	MutateNetworkArs(positive_agents[i].network, perturbation_scale);
	MutateNetworkArs(negative_agents[i].network, -perturbation_scale);
	//show_message(negative_agents[i].network)
	}


}



// Перезапуск симуляции
alarm[0] = 500; // Задержка для активации

/// Create Event
population_size = 25;
population_elite=0.1
learning_rate = 1; // Скорость обучения
positive_agents = [];
negative_agents = [];
agents = []; // Список агентов
fitness_scores = []; // Пригодность агентов

// Параметры CMA-ES
mean_network = new mlp_array([4, 5, 4, 2], [Tanh, Tanh, Tanh]); // Средняя сеть
//sigma = 0.5; // Шаг изменения параметров
perturbation_scale=0.5

// Создание агентов
for (var i = 0; i < population_size; i++) {
    var agent = instance_create_depth(x+random_range(-25,25), y+random_range(-25,25),-1, obj_agent);
    agent.network = new mlp_array([4, 5, 4, 2], [Tanh, Tanh, Tanh]);//mean_network;
    agents[i] = agent;
}

for (var i = 0; i < population_size / 2; i++) {
	// Создаём положительные и отрицательные копии центральной сети
	positive_agents[i] = agents[i];
	with positive_agents[i]
	image_blend=c_green
	negative_agents[i] = agents[i + population_size / 2];
	with negative_agents[i]
	image_blend=c_blue
}

ResetAgents(agents)




