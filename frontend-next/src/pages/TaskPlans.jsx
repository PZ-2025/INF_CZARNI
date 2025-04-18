import { useEffect, useState } from "react";

const TaskPlans = () => {
  const [tasks, setTasks] = useState([]);
  const [assignments, setAssignments] = useState({});
  const [employees, setEmployees] = useState([]);
  const [selectedEmployees, setSelectedEmployees] = useState([]);

  useEffect(() => {
    const fetchAssignments = async (taskId, token) => {
      try {
        const res = await fetch(`http://localhost:8080/assignments/task/${taskId}`, {
          headers: {
            "Authorization": `Bearer ${token}`
          }
        });
        if (!res.ok) throw new Error("Failed to fetch assignments");
        const data = await res.json();
        setAssignments(prev => ({ ...prev, [taskId]: data }));
      } catch (err) {
        console.error(`Error fetching assignments for task ${taskId}:`, err);
      }
    };

    const fetchTasks = async () => {
      try {
        const token = localStorage.getItem("token");
        const res = await fetch("http://localhost:8080/tasks", {
          headers: {
            "Authorization": `Bearer ${token}`
          }
        });
    
        if (!res.ok) throw new Error("Failed to fetch tasks");
    
        const data = await res.json();
        setTasks(data);

        data.forEach(task => {
          fetchAssignments(task.id, token);
        });
      } catch (err) {
        console.error("Error fetching tasks:", err);
      }
    };

    const fetchEmployees = async () => {
      try {
        const res = await fetch("http://localhost:8080/users");
        if (!res.ok) throw new Error(`HTTP error! Status: ${res.status}`);
    
        const text = await res.text();
        if (!text) throw new Error("Empty response from /users");
    
        const data = JSON.parse(text);
        const filtered = data.filter(user => user.role === "USER");
        setEmployees(filtered);
      } catch (err) {
        console.error("Error fetching users:", err);
      }
    };

    fetchTasks();
    fetchEmployees();

    // Dropdown behavior
    const dropdownToggles = document.querySelectorAll(".dropdown-toggle");

    dropdownToggles.forEach((toggle) => {
      toggle.addEventListener("click", function () {
        this.parentElement.classList.toggle("active");
      });
    });

    document.addEventListener("click", function (e) {
      if (!e.target.closest(".custom-dropdown")) {
        document.querySelectorAll(".custom-dropdown").forEach((dropdown) => {
          dropdown.classList.remove("active");
        });
      }
    });
  }, []);

  const handleCheckboxChange = (employeeId) => {
    setSelectedEmployees((prev) =>
      prev.includes(employeeId)
        ? prev.filter((id) => id !== employeeId)
        : [...prev, employeeId]
    );
  };

  return (
    <div className="container mx-auto p-4 bg-gray-900 text-gray-100">
      <div className="bg-gray-800 p-4 rounded-lg shadow mb-4 flex justify-between">
        <button className="bg-gray-700 hover:bg-gray-600 text-gray-100 px-4 py-2 rounded transition-colors">
          Przeglądaj zlecenia
        </button>
        <button className="bg-gray-700 hover:bg-gray-600 text-gray-100 px-4 py-2 rounded transition-colors">
          Generuj raport
        </button>
        <button className="bg-red-700 hover:bg-red-600 text-gray-100 px-4 py-2 rounded transition-colors">
          Wyloguj
        </button>
      </div>

      <div className="bg-gray-800 p-4 rounded-lg shadow mb-4 flex justify-between text-gray-300">
        <span>Nazwa/Id/Termin zlecenia</span>
        <span>Data</span>
        <span>Godzina</span>
      </div>

      <div className="bg-gray-800 p-4 rounded-lg shadow mb-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
          <div>
            <label className="block text-gray-400 mb-1 text-sm">Wprowadź nazwę zadania</label>
            <input
              type="text"
              className="w-full bg-gray-700 border border-gray-600 rounded p-2 text-gray-200"
            />
          </div>

          <div>
            <label className="block text-gray-400 mb-1 text-sm">Termin wykonania</label>
            <input
              type="date"
              className="w-full bg-gray-700 border border-gray-600 rounded p-2 text-gray-200"
            />
          </div>
        </div>

        <div className="flex flex-col md:flex-row items-end gap-4">
          <div className="flex-1">
            <label className="block text-gray-400 mb-1 text-sm">Wybierz pracowników</label>
            <div className="custom-dropdown relative">
              <button className="dropdown-toggle flex justify-between items-center w-full bg-gray-700 border border-gray-600 rounded p-2 text-gray-200">
                Lista pracowników <span className="arrow">▼</span>
              </button>
              <div className="dropdown-menu hidden absolute left-0 right-0 mt-1 bg-gray-700 border border-gray-600 rounded shadow-lg z-10">
                {employees.map((employee) => (
                  <label key={employee.id} className="block px-4 py-2 hover:bg-gray-600 cursor-pointer">
                    <input
                      type="checkbox"
                      className="mr-2"
                      checked={selectedEmployees.includes(employee.id)}
                      onChange={() => handleCheckboxChange(employee.id)}
                    />
                    {employee.firstName} {employee.lastName}
                  </label>
                ))}
              </div>
            </div>
          </div>

          <button className="bg-green-700 hover:bg-green-600 text-white w-10 h-10 rounded-full text-2xl flex items-center justify-center transition-colors">
            +
          </button>
        </div>
      </div>

      <div className="space-y-4 mb-6">
        {tasks.map((task) => (
          <div className="bg-gray-800 rounded-lg shadow overflow-hidden" key={task.id}>
            <div className="p-4 flex items-center justify-between border-b border-gray-700">
              <div className="font-medium">{task.taskName}</div>
              <div className="w-1/2 bg-gray-700 rounded-full h-2">
                <div
                  className="bg-purple-500 h-2 rounded-full"
                  style={{ width: "50%" }} // You can replace with actual progress if available
                ></div>
              </div>
            </div>

            <div className="p-4">
              <details className="mb-4">
                <summary className="cursor-pointer text-gray-300 hover:text-gray-100">
                  Lista przydzielonych pracowników
                </summary>
                <ul className="mt-2 ml-4 text-gray-400">
                  {assignments[task.id]?.map((assignment) => (
                    <li key={assignment.id}>
                      {assignment.user.firstName} {assignment.user.lastName}
                    </li>
                  )) || <li>Brak przypisanych pracowników</li>}
                </ul>
              </details>

              <div className="flex gap-2">
                <button className="bg-blue-700 hover:bg-blue-600 text-white px-4 py-2 rounded text-sm transition-colors">
                  Edycja
                </button>
                <button className="bg-red-700 hover:bg-red-600 text-white px-4 py-2 rounded text-sm transition-colors">
                  Usuń
                </button>
                <button className="bg-yellow-700 hover:bg-yellow-600 text-white px-4 py-2 rounded text-sm transition-colors">
                  Wstrzymaj
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="flex justify-center gap-4">
        <button className="bg-green-700 hover:bg-green-600 text-white px-6 py-2 rounded transition-colors">
          Dodaj zadanie
        </button>
        <button className="bg-blue-700 hover:bg-blue-600 text-white px-6 py-2 rounded transition-colors">
          Filtruj
        </button>
      </div>
    </div>
  );
};

export default TaskPlans;