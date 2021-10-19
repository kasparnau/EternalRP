const DB = require("./db");

async function db(string, data, cb) {
  ScheduleResourceTick(GetCurrentResourceName());
  try {
    await DB.initialized;

    let [results] = await DB.connection.query(string, data);

    if (cb) {
      cb(results);
    }

    return results;
  } catch (e) {
    console.error(e);
    console.error("\n" + string + " | " + data);

    if (cb) {
      cb();
    }

    return undefined;
  }
}

exports("execute", async (string, data, cb) => {
  db(string, data, cb);
});

// exports("executeSync", async (string, data) => {
//   return await db(string, data);
// });

// const DB = require("./db");
// const { performance } = require("perf_hooks");

// async function query(string, data, cb) {
//   try {
//     await DB.initialized;

//     const t0 = performance.now();
//     let results = await DB.connection.query({ sql: string }, data);
//     const time = performance.now() - t0;
//     if (time > 5) {
//       console.log("---------");
//       console.log(string, data);
//       console.log(`[Slow Query Warning] ${time}ms.`);
//     }

//     if (cb) {
//       cb(results);
//     }
//   } catch (e) {
//     console.error(e);
//     console.error("\n" + string + " | " + data);

//     DB.connection.query(
//       "INSERT INTO _sql_error_logs (query, data, error) VALUES (?, ?, ?)",
//       [string, data, e]
//     );

//     if (cb) {
//       cb(false);
//     }
//   }
// }

// exports("execute", (string, data, cb) => {
//   query(string, data, cb);
// });

// async function batch(string, data, cb) {
//   await DB.initialized;

//   try {
//     let result = await DB.connection.batch(string, data);

//     if (cb) {
//       cb(result);
//     }
//   } catch (err) {
//     DB.connection.query(
//       "INSERT INTO _sql_error_logs (query, data, error) VALUES (?, ?, ?)",
//       [string, data, e]
//     );

//     if (cb) {
//       cb(false);
//     }
//   }
// }

// exports("batch", (string, data, cb) => {
//   batch(string, data, cb);
// });

// exports("getConnection", () => {
//   return DB.connection;
// });
