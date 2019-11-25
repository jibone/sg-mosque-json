import test from 'ava';
import Ajv from 'ajv';
import schema from '../schema/mosque.schema.json';
import json from '../data/mosque.json';

test('Valid JSON file', t => {
  let ajv = new Ajv({allErrors: true});
  let validate = ajv.compile(schema);
  let valid = validate(json);

  if (!valid) {
    t.fail(validate.errors);
  }

  t.pass();
});
