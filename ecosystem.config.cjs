module.exports = {
  apps : [
      {
        name: "glosariusz",
        script: "./index.js",
        watch: false,
        instance_var: 'INSTANCE_ID',
        env: {
            "NODE_ENV": "production"
        }
      }
  ]
}