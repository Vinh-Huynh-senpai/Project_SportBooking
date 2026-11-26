IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO


CREATE DATABASE SportsBooking;
GO

USE SportsBooking;
GO


IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [Categories] (
        [Id] int NOT NULL IDENTITY,
        [Name] nvarchar(100) NOT NULL,
        [Description] nvarchar(1000) NULL,
        [ImagePath] nvarchar(500) NULL,
        [DisplayOrder] int NOT NULL,
        [IsActive] bit NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_Categories] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [FileDeletionJobs] (
        [Id] bigint NOT NULL IDENTITY,
        [RelativePath] nvarchar(500) NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        [CompletedAt] datetime2 NULL,
        [Attempts] int NOT NULL,
        [NextAttemptAt] datetime2 NULL,
        [LastError] nvarchar(1000) NULL,
        CONSTRAINT [PK_FileDeletionJobs] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [Roles] (
        [Id] smallint NOT NULL,
        [Name] nvarchar(20) NOT NULL,
        CONSTRAINT [PK_Roles] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [Venues] (
        [Id] int NOT NULL IDENTITY,
        [Name] nvarchar(150) NOT NULL,
        [Address] nvarchar(300) NOT NULL,
        [Phone] nvarchar(20) NOT NULL,
        [IsActive] bit NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        CONSTRAINT [PK_Venues] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [Members] (
        [Id] uniqueidentifier NOT NULL,
        [RoleId] smallint NOT NULL,
        [GivenName] nvarchar(50) NOT NULL,
        [Surname] nvarchar(50) NOT NULL,
        [Email] nvarchar(254) NOT NULL,
        [NormalizedEmail] nvarchar(254) NOT NULL,
        [Phone] nvarchar(20) NULL,
        [PasswordHash] nvarchar(255) NOT NULL,
        [IsLocked] bit NOT NULL,
        [EmailConfirmed] bit NOT NULL,
        [SecurityVersion] int NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        [UpdatedAt] datetime2 NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_Members] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Members_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [Products] (
        [Id] int NOT NULL IDENTITY,
        [CategoryId] int NOT NULL,
        [VenueId] int NOT NULL,
        [Type] nvarchar(10) NOT NULL,
        [Name] nvarchar(150) NOT NULL,
        [Description] nvarchar(max) NULL,
        [ImagePath] nvarchar(500) NULL,
        [BasePrice] decimal(18,2) NOT NULL,
        [Unit] nvarchar(30) NOT NULL,
        [IsActive] bit NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        [UpdatedAt] datetime2 NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_Products] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_Product_Price] CHECK ([BasePrice] >= 0),
        CONSTRAINT [CK_Product_Type] CHECK ([Type] IN ('Court','Service')),
        CONSTRAINT [FK_Products_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Products_Venues_VenueId] FOREIGN KEY ([VenueId]) REFERENCES [Venues] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [AuthSessions] (
        [Id] uniqueidentifier NOT NULL,
        [MemberId] uniqueidentifier NOT NULL,
        [RefreshTokenHash] varbinary(32) NOT NULL,
        [ExpiresAt] datetime2 NOT NULL,
        [RevokedAt] datetime2 NULL,
        [CreatedAt] datetime2 NOT NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_AuthSessions] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AuthSessions_Members_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [Members] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [Carts] (
        [Id] uniqueidentifier NOT NULL,
        [MemberId] uniqueidentifier NOT NULL,
        [UpdatedAt] datetime2 NOT NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_Carts] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Carts_Members_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [Members] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [EmailChallenges] (
        [Id] uniqueidentifier NOT NULL,
        [MemberId] uniqueidentifier NOT NULL,
        [Purpose] nvarchar(30) NOT NULL,
        [CodeHash] varbinary(32) NOT NULL,
        [ExpiresAt] datetime2 NOT NULL,
        [ConsumedAt] datetime2 NULL,
        [FailedAttempts] smallint NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        CONSTRAINT [PK_EmailChallenges] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_EmailChallenges_Members_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [Members] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [Orders] (
        [Id] uniqueidentifier NOT NULL,
        [OrderCode] nvarchar(40) NOT NULL,
        [MemberId] uniqueidentifier NOT NULL,
        [VenueId] int NOT NULL,
        [BookingDate] date NOT NULL,
        [CustomerName] nvarchar(120) NOT NULL,
        [CustomerPhone] nvarchar(20) NOT NULL,
        [Status] nvarchar(30) NOT NULL,
        [TotalAmount] decimal(18,2) NOT NULL,
        [DepositAmount] decimal(18,2) NOT NULL,
        [HoldExpiresAt] datetime2 NULL,
        [Note] nvarchar(1000) NULL,
        [IdempotencyKey] nvarchar(64) NOT NULL,
        [RequestHash] varbinary(32) NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        [UpdatedAt] datetime2 NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_Orders] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_Order_Money] CHECK ([TotalAmount] >= 0 AND [DepositAmount] >= 0 AND [DepositAmount] <= [TotalAmount]),
        CONSTRAINT [CK_Order_Status] CHECK ([Status] IN ('PendingDeposit','Confirmed','Playing','Completed','Cancelled')),
        CONSTRAINT [FK_Orders_Members_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [Members] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Orders_Venues_VenueId] FOREIGN KEY ([VenueId]) REFERENCES [Venues] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [CourtProfiles] (
        [ProductId] int NOT NULL,
        [Capacity] smallint NOT NULL,
        [Surface] nvarchar(100) NULL,
        [Indoor] bit NOT NULL,
        [SlotMinutes] smallint NOT NULL,
        CONSTRAINT [PK_CourtProfiles] PRIMARY KEY ([ProductId]),
        CONSTRAINT [CK_CourtProfile_Capacity] CHECK ([Capacity] > 1),
        CONSTRAINT [CK_CourtProfile_SlotMinutes] CHECK ([SlotMinutes] = 30),
        CONSTRAINT [FK_CourtProfiles_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [CartItems] (
        [Id] bigint NOT NULL IDENTITY,
        [CartId] uniqueidentifier NOT NULL,
        [ProductId] int NOT NULL,
        [PlayDate] date NULL,
        [StartTime] time(0) NULL,
        [SlotCount] smallint NULL,
        [Quantity] int NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        CONSTRAINT [PK_CartItems] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_CartItem_Quantity] CHECK ([Quantity] > 0),
        CONSTRAINT [CK_CartItem_Time] CHECK (([PlayDate] IS NULL AND [StartTime] IS NULL AND [SlotCount] IS NULL) OR ([PlayDate] IS NOT NULL AND [StartTime] IS NOT NULL AND [SlotCount] IS NOT NULL AND [SlotCount] > 0 AND [Quantity] = 1)),
        CONSTRAINT [FK_CartItems_Carts_CartId] FOREIGN KEY ([CartId]) REFERENCES [Carts] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_CartItems_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [CheckInTokens] (
        [Id] uniqueidentifier NOT NULL,
        [OrderId] uniqueidentifier NOT NULL,
        [TokenHash] varbinary(32) NOT NULL,
        [ExpiresAt] datetime2 NOT NULL,
        [UsedAt] datetime2 NULL,
        [RevokedAt] datetime2 NULL,
        [UsedByMemberId] uniqueidentifier NULL,
        CONSTRAINT [PK_CheckInTokens] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_CheckInTokens_Members_UsedByMemberId] FOREIGN KEY ([UsedByMemberId]) REFERENCES [Members] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_CheckInTokens_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [OrderItems] (
        [Id] bigint NOT NULL IDENTITY,
        [OrderId] uniqueidentifier NOT NULL,
        [ProductId] int NOT NULL,
        [ProductName] nvarchar(150) NOT NULL,
        [ProductType] nvarchar(10) NOT NULL,
        [Unit] nvarchar(30) NOT NULL,
        [Quantity] int NOT NULL,
        [UnitPrice] decimal(18,2) NULL,
        [LineTotal] decimal(18,2) NOT NULL,
        CONSTRAINT [PK_OrderItems] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_OrderItem_Money] CHECK ([Quantity] > 0 AND [LineTotal] >= 0 AND ([UnitPrice] IS NULL OR [UnitPrice] >= 0)),
        CONSTRAINT [FK_OrderItems_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_OrderItems_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [OrderStatusHistories] (
        [Id] bigint NOT NULL IDENTITY,
        [OrderId] uniqueidentifier NOT NULL,
        [FromStatus] nvarchar(30) NULL,
        [ToStatus] nvarchar(30) NOT NULL,
        [ChangedByMemberId] uniqueidentifier NULL,
        [Reason] nvarchar(500) NULL,
        [CreatedAt] datetime2 NOT NULL,
        CONSTRAINT [PK_OrderStatusHistories] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_OrderStatusHistories_Members_ChangedByMemberId] FOREIGN KEY ([ChangedByMemberId]) REFERENCES [Members] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_OrderStatusHistories_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [Payments] (
        [Id] uniqueidentifier NOT NULL,
        [OrderId] uniqueidentifier NOT NULL,
        [Kind] nvarchar(20) NOT NULL,
        [Method] nvarchar(20) NOT NULL,
        [Amount] decimal(18,2) NOT NULL,
        [Status] nvarchar(20) NOT NULL,
        [TransferContent] nvarchar(100) NOT NULL,
        [ExternalReference] nvarchar(100) NULL,
        [VerifiedByMemberId] uniqueidentifier NULL,
        [ConfirmedAt] datetime2 NULL,
        [CreatedAt] datetime2 NOT NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_Payments] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_Payment_Amount] CHECK ([Amount] > 0),
        CONSTRAINT [CK_Payment_Kind] CHECK ([Kind] IN ('Deposit','Balance','Refund')),
        CONSTRAINT [CK_Payment_Status] CHECK ([Status] IN ('Pending','Confirmed','Rejected')),
        CONSTRAINT [FK_Payments_Members_VerifiedByMemberId] FOREIGN KEY ([VerifiedByMemberId]) REFERENCES [Members] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Payments_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [CourtPriceRules] (
        [Id] int NOT NULL IDENTITY,
        [CourtId] int NOT NULL,
        [DayOfWeek] tinyint NOT NULL,
        [StartTime] time(0) NOT NULL,
        [EndTime] time(0) NOT NULL,
        [PricePerHour] decimal(18,2) NOT NULL,
        [EffectiveFrom] date NOT NULL,
        [EffectiveTo] date NULL,
        [IsActive] bit NOT NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_CourtPriceRules] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_CourtPriceRule_Day] CHECK ([DayOfWeek] BETWEEN 0 AND 6),
        CONSTRAINT [CK_CourtPriceRule_Period] CHECK ([StartTime] < [EndTime] AND ([EffectiveTo] IS NULL OR [EffectiveFrom] <= [EffectiveTo])),
        CONSTRAINT [CK_CourtPriceRule_Price] CHECK ([PricePerHour] >= 0),
        CONSTRAINT [FK_CourtPriceRules_CourtProfiles_CourtId] FOREIGN KEY ([CourtId]) REFERENCES [CourtProfiles] ([ProductId]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [CourtSchedules] (
        [Id] int NOT NULL IDENTITY,
        [CourtId] int NOT NULL,
        [DayOfWeek] tinyint NOT NULL,
        [OpenTime] time(0) NOT NULL,
        [CloseTime] time(0) NOT NULL,
        [IsClosed] bit NOT NULL,
        CONSTRAINT [PK_CourtSchedules] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_CourtSchedule_Day] CHECK ([DayOfWeek] BETWEEN 0 AND 6),
        CONSTRAINT [CK_CourtSchedule_Hours] CHECK ([IsClosed] = 1 OR [OpenTime] < [CloseTime]),
        CONSTRAINT [FK_CourtSchedules_CourtProfiles_CourtId] FOREIGN KEY ([CourtId]) REFERENCES [CourtProfiles] ([ProductId]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [CourtSlots] (
        [Id] bigint NOT NULL IDENTITY,
        [CourtId] int NOT NULL,
        [PlayDate] date NOT NULL,
        [StartTime] time(0) NOT NULL,
        [EndTime] time(0) NOT NULL,
        [IsBlocked] bit NOT NULL,
        [BlockReason] nvarchar(300) NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_CourtSlots] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_CourtSlot_Duration] CHECK (DATEDIFF(MINUTE,[StartTime],[EndTime]) = 30 AND DATEPART(MINUTE,[StartTime]) IN (0,30) AND DATEPART(SECOND,[StartTime]) = 0 AND DATEPART(SECOND,[EndTime]) = 0),
        CONSTRAINT [FK_CourtSlots_CourtProfiles_CourtId] FOREIGN KEY ([CourtId]) REFERENCES [CourtProfiles] ([ProductId]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [MatchRooms] (
        [Id] uniqueidentifier NOT NULL,
        [OrderItemId] bigint NOT NULL,
        [OwnerMemberId] uniqueidentifier NOT NULL,
        [Title] nvarchar(150) NOT NULL,
        [RequiredLevel] nvarchar(30) NOT NULL,
        [NeededPlayers] smallint NOT NULL,
        [CostPerPerson] decimal(18,2) NOT NULL,
        [Description] nvarchar(1000) NULL,
        [Status] nvarchar(20) NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_MatchRooms] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_MatchRoom_Slots] CHECK ([NeededPlayers] > 0 AND [CostPerPerson] >= 0),
        CONSTRAINT [CK_MatchRoom_Status] CHECK ([Status] IN ('Open','Full','Closed')),
        CONSTRAINT [FK_MatchRooms_Members_OwnerMemberId] FOREIGN KEY ([OwnerMemberId]) REFERENCES [Members] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_MatchRooms_OrderItems_OrderItemId] FOREIGN KEY ([OrderItemId]) REFERENCES [OrderItems] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [OrderItemSlots] (
        [OrderItemId] bigint NOT NULL,
        [CourtSlotId] bigint NOT NULL,
        [UnitPrice] decimal(18,2) NOT NULL,
        CONSTRAINT [PK_OrderItemSlots] PRIMARY KEY ([OrderItemId], [CourtSlotId]),
        CONSTRAINT [CK_OrderItemSlot_Price] CHECK ([UnitPrice] >= 0),
        CONSTRAINT [FK_OrderItemSlots_CourtSlots_CourtSlotId] FOREIGN KEY ([CourtSlotId]) REFERENCES [CourtSlots] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_OrderItemSlots_OrderItems_OrderItemId] FOREIGN KEY ([OrderItemId]) REFERENCES [OrderItems] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [MatchRequests] (
        [Id] uniqueidentifier NOT NULL,
        [RoomId] uniqueidentifier NOT NULL,
        [MemberId] uniqueidentifier NOT NULL,
        [Status] nvarchar(20) NOT NULL,
        [Message] nvarchar(500) NULL,
        [ReviewedByMemberId] uniqueidentifier NULL,
        [ReviewedAt] datetime2 NULL,
        [CreatedAt] datetime2 NOT NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_MatchRequests] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_MatchRequest_Status] CHECK ([Status] IN ('Pending','Approved','Rejected','Withdrawn')),
        CONSTRAINT [FK_MatchRequests_MatchRooms_RoomId] FOREIGN KEY ([RoomId]) REFERENCES [MatchRooms] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_MatchRequests_Members_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [Members] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_MatchRequests_Members_ReviewedByMemberId] FOREIGN KEY ([ReviewedByMemberId]) REFERENCES [Members] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE TABLE [SlotReservations] (
        [CourtSlotId] bigint NOT NULL,
        [OrderItemId] bigint NOT NULL,
        CONSTRAINT [PK_SlotReservations] PRIMARY KEY ([CourtSlotId]),
        CONSTRAINT [FK_SlotReservations_OrderItemSlots_OrderItemId_CourtSlotId] FOREIGN KEY ([OrderItemId], [CourtSlotId]) REFERENCES [OrderItemSlots] ([OrderItemId], [CourtSlotId]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_AuthSessions_MemberId] ON [AuthSessions] ([MemberId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_AuthSessions_RefreshTokenHash] ON [AuthSessions] ([RefreshTokenHash]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_CartItems_CartId] ON [CartItems] ([CartId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_CartItems_ProductId] ON [CartItems] ([ProductId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Carts_MemberId] ON [Carts] ([MemberId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Categories_Name] ON [Categories] ([Name]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_CheckInTokens_OrderId] ON [CheckInTokens] ([OrderId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_CheckInTokens_TokenHash] ON [CheckInTokens] ([TokenHash]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_CheckInTokens_UsedByMemberId] ON [CheckInTokens] ([UsedByMemberId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_CourtPriceRules_CourtId] ON [CourtPriceRules] ([CourtId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_CourtSchedules_CourtId_DayOfWeek] ON [CourtSchedules] ([CourtId], [DayOfWeek]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_CourtSlots_CourtId_PlayDate_StartTime] ON [CourtSlots] ([CourtId], [PlayDate], [StartTime]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_EmailChallenges_MemberId] ON [EmailChallenges] ([MemberId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_MatchRequests_MemberId] ON [MatchRequests] ([MemberId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_MatchRequests_ReviewedByMemberId] ON [MatchRequests] ([ReviewedByMemberId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_MatchRequests_RoomId_MemberId] ON [MatchRequests] ([RoomId], [MemberId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [IX_MatchRooms_OrderItemId] ON [MatchRooms] ([OrderItemId]) WHERE [Status] IN (''Open'',''Full'')');
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_MatchRooms_OwnerMemberId] ON [MatchRooms] ([OwnerMemberId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Members_NormalizedEmail] ON [Members] ([NormalizedEmail]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_Members_RoleId] ON [Members] ([RoleId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_OrderItems_OrderId] ON [OrderItems] ([OrderId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_OrderItems_ProductId] ON [OrderItems] ([ProductId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_OrderItemSlots_CourtSlotId] ON [OrderItemSlots] ([CourtSlotId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_Orders_MemberId_CreatedAt_Id] ON [Orders] ([MemberId], [CreatedAt], [Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Orders_MemberId_IdempotencyKey] ON [Orders] ([MemberId], [IdempotencyKey]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Orders_OrderCode] ON [Orders] ([OrderCode]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_Orders_Status_HoldExpiresAt] ON [Orders] ([Status], [HoldExpiresAt]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_Orders_VenueId] ON [Orders] ([VenueId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_OrderStatusHistories_ChangedByMemberId] ON [OrderStatusHistories] ([ChangedByMemberId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_OrderStatusHistories_OrderId] ON [OrderStatusHistories] ([OrderId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [IX_Payments_ExternalReference] ON [Payments] ([ExternalReference]) WHERE [ExternalReference] IS NOT NULL');
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_Payments_OrderId] ON [Payments] ([OrderId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_Payments_VerifiedByMemberId] ON [Payments] ([VerifiedByMemberId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_Products_CategoryId_IsActive_CreatedAt_Id] ON [Products] ([CategoryId], [IsActive], [CreatedAt], [Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_Products_VenueId] ON [Products] ([VenueId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Roles_Name] ON [Roles] ([Name]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    CREATE INDEX [IX_SlotReservations_OrderItemId_CourtSlotId] ON [SlotReservations] ([OrderItemId], [CourtSlotId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121092956_InitialSportsBooking'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20261121092956_InitialSportsBooking', N'8.0.11');
END;
GO

COMMIT;
GO
