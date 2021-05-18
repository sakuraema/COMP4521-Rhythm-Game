using UnityEngine;

public class FireEventsWithinTimeframe : BatchOfEvents
{
	public Timeframe timeframe = Timeframe.onUpdate;
	public FourFloatsEvent triggeredWithinTimeframe;

	private void Awake ( )
	{
		if ( timeframe != Timeframe.onAwake) return;
		FireEvents ( );
	}

	private void Start ( )
	{
		if ( timeframe != Timeframe.onStart ) return;
		FireEvents ( );
	}

	private void OnEnable ( )
	{
		nextTriggeringAvailability = Time.time + delayBetweenTriggers;
		if ( timeframe != Timeframe.onEnable ) return;
		FireEvents ( );
	}

	private void Update ( ) 
	{
		if ( timeframe != Timeframe.onUpdate ) return;
		FireEvents ( );
	}

	private void FixedUpdate ( )
	{
		if ( timeframe != Timeframe.onFixedUpdate ) return;
		FireEvents ( );
	}

	private void LateUpdate ( )
	{
		if ( timeframe != Timeframe.onLateUpdate ) return;
		FireEvents ( );
	}

	private void OnDestroy ( )
	{
		if ( timeframe != Timeframe.onDestroy ) return;
		FireEvents ( );
	}

	private void OnDisable ( )
	{
		if ( timeframe != Timeframe.onDisable ) return;
		FireEvents ( );
	}

	public override void FireEvents ( bool forceTriggering = false)
	{
		if ( !forceTriggering && !allowedToTrigger) return;

		triggeredWithinTimeframe.Invoke (
			Time.timeScale,
			Time.time,
			(timeframe == Timeframe.onFixedUpdate)
			? Time.fixedDeltaTime : Time.deltaTime,
			Time.smoothDeltaTime );
	}
}
