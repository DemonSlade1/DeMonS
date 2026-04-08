import dotenv from 'dotenv';
dotenv.config();

import { Request, Response } from 'express';
import { Pool } from 'pg'

type Config ={
  host?: string,
  port?: number,
  user?: string,
  password?: string,
  database?: string,
}

const configs : Config = {
  host: "localhost",
  port: 5332,
  user: process.env.POSTGRES_REG_USER,
  password: process.env.POSTGRES_REG_PASSWORD,
  database: process.env.POSTGRES_DB
}

// Create pool instance to handle all client instances of the app
let pool: Pool | undefined;
 
const getPool = (): Pool => {
  if (!pool) {
    pool = new Pool(configs);
 
    pool.on('error', (err) => {
      process.exit(1);
    });
  }
  return pool;
};

const myPool = getPool();

const getUsers = (request: Request, response: Response) => {
  myPool.query('SELECT * FROM users ORDER BY id ASC', (error: any, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results)
  })
}

const getUserById = (request: Request, response: Response) => {
  const idParam = request.params.id;

  if (Array.isArray(idParam)) {
    return response.status(400).send('Invalid id parameter');
  }

  const id = parseInt(idParam, 10);

  myPool.query('SELECT * FROM users WHERE id = $1', [id], (error: any, results: { rows: any; }) => {
    if (error) {
      throw error;
    }
    response.status(200).json(results.rows);
  });
};

const createUser = (request: Request, response: Response) => {
  const { name, email } = request.body

  myPool.query('INSERT INTO users (name, email) VALUES ($1, $2)', [name, email], (error: any, results) => {
    if (error) {
      throw error
    }
    response.status(201).send(`User added with ID: ${results}`)
  })
}

const updateUser = (request: Request, response: Response) => {
  const idParam = request.params.id;

  if (Array.isArray(idParam)) {
    return response.status(400).send('Invalid id parameter');
  }

  const id = parseInt(idParam, 10);
  const { name, email } = request.body;

  myPool.query(
    'UPDATE users SET name = $1, email = $2 WHERE id = $3',
    [name, email, id],
    (error: any, results: any) => {
      if (error) {
        throw error;
      }
      response.status(200).send(`User modified with ID: ${id}`);
    }
  );
};

const deleteUser = (request: Request, response: Response) => {
  const idParam = request.params.id;

  if (Array.isArray(idParam)) {
    return response.status(400).send('Invalid id parameter');
  }

  const id = parseInt(idParam, 10);

  myPool.query('DELETE FROM users WHERE id = $1', [id], (error: any, results: any) => {
    if (error) {
      throw error;
    }
    response.status(200).send(`User deleted with ID: ${id}`);
  });
};

module.exports = {
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
}