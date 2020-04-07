var bleno = require('bleno');
var util = require('util');

var BlenoCharacteristic = bleno.Characteristic;

var WriteTimeCharacteristic = function() {
    WriteTimeCharacteristic.super_.call(this, {
        uuid: '0a60d08c-80c9-4332-899b-27d54b14f0d2',
        properties: ['write']
    });

    this._value = new Buffer(0);
    this._updateValueCallback = null;
};

util.inherits(WriteTimeCharacteristic, BlenoCharacteristic);
module.exports = WriteTimeCharacteristic;

WriteTimeCharacteristic.prototype.onWriteRequest = function(data, offset, withoutResponse, callback) {
	this._value = data;
    console.log('CustomCharacteristic - onWriteRequest: value = ' + this._value.toString('utf8'));
	callback(this.RESULT_SUCCESS);
};