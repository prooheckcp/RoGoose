--!strict
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Signal = require(script.Vendor.Signal)
local Schema = require(script.Classes.Schema)
local Model = require(script.Classes.Model)
local Profile = require(script.Classes.Profile)
local ModelType = require(script.Enums.ModelType)

local Trove = require(script.Vendor.Trove)
local Signals = require(script.Constants.Signals)

--functions
local GeneratePlayerKey = require(script.Functions.GeneratePlayerKey)

local ERROR_TAG: string = "[RoGoose] [ERROR]:"
local CLIENT_E
local SESSION_LOCK_DATASTORE: string = "SessionLockStore"

local RoGoose = {}

--Exposed types
export type Schema = Schema.Schema
export type Model = Model.Model
export type Profile = Profile.Profile
export type ModelType = ModelType.ModelType

--Exposed Classes
RoGoose.Schema = Schema
RoGoose.Model = Model

--Exposed Enums
RoGoose.ModelType = ModelType

function RoGoose:_Init()

end

RoGoose:_Init()

return RoGoose