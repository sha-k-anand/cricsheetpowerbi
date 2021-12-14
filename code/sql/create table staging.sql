CREATE TABLE [dbo].[Staging_JSON2](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FullLine] [nvarchar](max) NULL,
	[FileName] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]



