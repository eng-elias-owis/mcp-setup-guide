#!/usr/bin/env node
/**
 * Simple HTTP MCP Server
 * A lightweight alternative to the archived fetch MCP
 * Works with npx - no installation needed
 */

const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');
const {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} = require('@modelcontextprotocol/sdk/types.js');

const server = new Server(
  {
    name: 'simple-http-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'http_request',
        description: 'Make HTTP requests (GET, POST, PUT, DELETE)',
        inputSchema: {
          type: 'object',
          properties: {
            method: {
              type: 'string',
              description: 'HTTP method',
              enum: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
              default: 'GET'
            },
            url: {
              type: 'string',
              description: 'Full URL including protocol'
            },
            headers: {
              type: 'object',
              description: 'Request headers (optional)',
              additionalProperties: { type: 'string' }
            },
            body: {
              type: 'string',
              description: 'Request body for POST/PUT (optional)'
            }
          },
          required: ['url']
        }
      }
    ]
  };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === 'http_request') {
    const { method = 'GET', url, headers = {}, body } = request.params.arguments;
    
    try {
      const fetch = (await import('node-fetch')).default;
      
      const options = {
        method,
        headers: {
          'User-Agent': 'Simple-HTTP-MCP/1.0',
          ...headers
        }
      };
      
      if (body && (method === 'POST' || method === 'PUT' || method === 'PATCH')) {
        options.body = body;
        if (!options.headers['Content-Type']) {
          options.headers['Content-Type'] = 'application/json';
        }
      }
      
      const response = await fetch(url, options);
      const responseBody = await response.text();
      
      return {
        content: [
          {
            type: 'text',
            text: `Status: ${response.status} ${response.statusText}\n\nHeaders:\n${JSON.stringify(Object.fromEntries(response.headers), null, 2)}\n\nBody:\n${responseBody}`
          }
        ]
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `Error: ${error.message}`
          }
        ],
        isError: true
      };
    }
  }
  
  throw new Error(`Unknown tool: ${request.params.name}`);
});

// Start server
const transport = new StdioServerTransport();
server.connect(transport).catch(console.error);
