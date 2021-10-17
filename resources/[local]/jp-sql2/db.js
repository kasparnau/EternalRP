const { createConnection } = require("mysql2/promise");

let MySQL_URI = GetConvar("mysql_uri", "");

if (!MySQL_URI) console.error("mysql_uri convar not set!");

class DB {
  constructor() {
    this._initialized = new Promise((resolve) => {
      this._initializedResolver = resolve;
    });
    this.connect();
  }

  get connection() {
    return this._connection;
  }

  get initialized() {
    return this._initialized;
  }

  handleDisconnect = async () => {
    var self = this;

    try {
      this._connection = await createConnection(MySQL_URI);

      this._connection.connect(function (err) {
        if (err) {
          console.log("error when connecting to db:", errr);
          setTimeout(self.handleDisconnect, 2000);
        }
      });

      this._connection.on("error", function (err) {
        console.log("db err", err);
        self.handleDisconnect();
      });
    } catch {
      setTimeout(self.handleDisconnect, 2000);
    }
  };

  async connect() {
    await this.handleDisconnect(); //INIT
    await new Promise((r) => setTimeout(r, 2000));
    this._initializedResolver();
  }
}

const instance = new DB();
module.exports = instance;

// const { createConnection } = require("mysql2/promise");

// let MySQL_URI = GetConvar("mysql_uri", "");

// if (!MySQL_URI) console.error("mysql_uri convar not set!");
// class DB {
//   constructor() {
//     this._initialized = new Promise((resolve) => {
//       this._initializedResolver = resolve;
//     });
//     this.connect();
//   }

//   get connection() {
//     return this._connection;
//   }

//   get initialized() {
//     return this._initialized;
//   }

//   async connect() {
//     this._connection = await createConnection(MySQL_URI);
//     this._initializedResolver();
//   }
// }

// const instance = new DB();

// module.exports = instance;
