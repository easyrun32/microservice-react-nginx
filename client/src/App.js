import { useEffect, useState } from "react";
import axios from "axios";
const App = () => {
  const [user, setUser] = useState({});
  const [task, setTask] = useState({});
  useEffect(() => {
    axios.get("/api/users").then((res) => {
      setUser(res.data);
    });
    axios.get("/api/task").then((res) => {
      setTask(res.data);
    });
  }, []);

  return (
    <div>
      Hello <b />
      {user.server} server and {task.server} server
    </div>
  );
};

export default App;
