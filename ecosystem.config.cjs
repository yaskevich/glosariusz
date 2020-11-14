module.exports = {
  apps : [
      {
        name: "glosariusz",
        script: "./index.js",
        watch: false,
        instance_var: 'INSTANCE_ID',
        env: {
            "PORT": 3020,
            "NODE_ENV": "production"
        }
      }
  ]
}